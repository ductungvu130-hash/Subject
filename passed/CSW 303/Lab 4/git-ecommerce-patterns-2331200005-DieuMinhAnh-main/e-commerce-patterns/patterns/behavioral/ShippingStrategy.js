// The Context class that uses a strategy
class ShippingCalculator {
    setStrategy(strategy) {
        this.strategy = strategy;
    }

    calculate(packageDetails) {
        // TODO: Call the `calculate` method on the currently set strategy object.
        // Pass the `packageDetails` to it and return the result.
        if (!this.strategy) {
            throw new Error('[ShippingCalculator] No strategy set.');
        }
        return this.strategy.calculate(packageDetails);
    }
}

// The Strategy interface (conceptual in JS)
class ShippingStrategy {
    calculate(packageDetails) {
        throw new Error("This method should be overridden!");
    }
}

// Concrete Strategy 1: Flat Rate
class FlatRateStrategy extends ShippingStrategy {
    calculate(packageDetails) {
        // TODO: Return a fixed shipping cost, e.g., 10.
        const FLAT_RATE = 10;
        console.log(`[FlatRate] Fixed cost: $${FLAT_RATE}`);
        return FLAT_RATE;
    }
}

// Concrete Strategy 2: Weight-Based
class WeightBasedStrategy extends ShippingStrategy {
    calculate(packageDetails) {
        // TODO: Return a cost based on the package weight.
        // For example, $3 per kilogram. `packageDetails.weight` will be in kg.
        const RATE_PER_KG = 3;
        const cost = packageDetails.weight * RATE_PER_KG;
        console.log(`[WeightBased] ${packageDetails.weight}kg × $${RATE_PER_KG}/kg = $${cost}`);
        return cost;
    }
}

export { ShippingCalculator, FlatRateStrategy, WeightBasedStrategy,ShippingStrategy };
