# CodeCompanion workflow

This branch uses CodeCompanion's HTTP adapter to talk to llama.cpp. The model
(such as Qwen) runs on the host; Neovim runs in this VM.

## Connect to the host

Set the base URL reachable **from the VM** in your shell before starting Neovim.
Add the export to `~/.bashrc` for future Bash sessions. Replace the example address:

```bash
export LLAMA_CPP_URL="http://YOUR_HOST_ADDRESS:8080"
```

The server must listen on an interface the VM can reach. `127.0.0.1` inside the VM
means the VM itself, unless you have forwarded the server through a local tunnel.
The config retains localhost as a fallback for machines running llama.cpp locally.
Use a base URL without `/v1`; the adapter adds the API paths.

Check connectivity from the VM:

```bash
curl --fail --show-error "$LLAMA_CPP_URL/v1/models"
```

The adapter discovers the served model automatically. To choose a particular model
ID returned by that endpoint, optionally set:

```bash
export LLAMA_CPP_MODEL="MODEL_ID_FROM_THE_SERVER"
```

Restart Neovim after changing environment variables. This config retains the
existing `local` API key; a server configured to require a different key needs
that adapter setting adjusted. The host address is intentionally not committed.

## Shortcuts

The leader key is **Space**.

| Keys | What happens |
| --- | --- |
| Space+a+i | Ask for an edit, automatically supplying the current file |
| Visual selection, then Space+a+i | Edit only the selection, with the whole file as context |
| Space+a+g | Submit the `gippity` comment under the cursor |
| Space+a+c | Open/focus chat with the current file attached; inside chat, hide it |
| Space+a+r | Refresh the current source file in chat (or the last source from inside chat) |
| Space+a+a | Existing CodeCompanion action palette |

Inline requests include the filename and current buffer contents, including
unsaved edits. Normal-mode edits target the file; visual edits target the selected
characters or lines. Rectangular selections are not supported by this wrapper.
Canceling the prompt sends nothing. If the buffer changes while the prompt is
open, invoke the shortcut again so the edit range stays accurate.

Chat does not submit a request merely by opening. Attached buffers are configured
to refresh their full contents before subsequent messages. Opening chat from a
different source file attaches that file too. Remove old context entries from the
chat when they are no longer relevant to avoid filling the model's context window.
Related files are not sent automatically unless you attach them.

## Comments starting with gippity

Write the instruction using the current language's comment syntax. No `@` or
backslash is needed:

```java
// gippity implement this method and reject duplicate IDs
```

```python
# gippity simplify this function without changing its behavior
```

```lua
-- gippity add a check for missing input
```

```c
/* gippity explain the edge cases in documentation
 * and handle an empty input array.
 */
```

Put the cursor on the comment and press **Space+a+g**. The comment is the prompt;
the whole current file supplies context. The model is asked to remove that
instruction comment in its proposed edit. The shortcut itself does not delete it.

The prefix is lowercase `gippity`, followed by whitespace or a colon and a nonempty
instruction. `@gippity`, `gippityish`, ordinary code, and strings are not directives.
There is no automatic submission on save or while typing.

When a Tree-sitter parser is available, comments are identified through the syntax
tree, including supported block comments. Otherwise the buffer's `commentstring`
is used for a complete comment on the current line. For an unfamiliar language,
check `:set commentstring?` and install its parser if you need multiline comments.

## Reviewing and testing

CodeCompanion's configured diff interface shows proposed inline changes. Review
and accept/reject them there; normal file saves remain under your control.
Large files send more context and can take longer on a local model.

Focused local tests (after installing the config's plugins and parsers):

```bash
cd ~/.config/nvim
nvim --headless -u NONE -l tests/ai.lua
```

The tests cover multiple comment syntaxes, rejecting strings and invalid prefixes,
selection targeting, canceled prompts, and source changes during prompting.
The inline and chat pipelines have also been checked locally with model requests
intercepted. A live host-model response still requires a reachable server URL.
