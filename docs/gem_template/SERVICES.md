> **Architecture Documentation**
> *   **Canonical Source:** [bowerbird-app/gem_template](https://github.com/bowerbird-app/gem_template/tree/main/docs/gem_template)
> *   **Last Updated:** November 15, 2026
>
> *Maintainers: Please update the date above when modifying this file.*

---

# Service Objects

Business logic in GemTemplate is encapsulated in service objects using the Result monad pattern.

---

## Usage

Subclass core `RecordingStudio::Services::BaseService`. Do not copy `BaseService` into the addon, and do not add `GemTemplate::Services::ExampleService`.

```ruby
class MyService < RecordingStudio::Services::BaseService
  def initialize(param:)
    @param = param
  end

  private

  def perform
    success(@param)
  end
end

result = MyService.call(param: "World")
```
