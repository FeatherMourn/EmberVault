# Character template coverage

The 1.0 KFC template export contains:

- 62 templates with `keen::ecs::CharacterSetup`.
- 59 templates with `keen::ecs::NewCharacterSetup`.
- 303 templates with `keen::ecs::ScaleComponent`.
- 63 templates containing hair payload fields.
- 63 templates containing beard payload fields.

This supports a template-driven appearance path and gives us concrete static candidates for hair, beard, and scale research. It does not identify the live player entity or prove that template changes affect an active character. Those remain runtime ownership and guarded-write questions.
