component accessors="true" {
    property name="greeting" type="string" default="Hello";

    /** Greets someone by name. */
    public string function greet(required string name) {
        var out = "#variables.greeting#, #arguments.name#!";
        return out ?: "";
    }
}
