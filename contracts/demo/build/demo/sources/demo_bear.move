// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

module demo::demo_bear;

// Import necessary modules from the standard library and Sui framework.
use std::string::{String, utf8}; // For handling strings.
use sui::{display, package};    // For managing object metadata and packages.

// === DemoBear Structures ===

/// Core structure representing a "DemoBear."
/// - `id`: A unique identifier for the bear.
/// - `name`: The name of the bear, represented as a `String`.
public struct DemoBear has key, store {
    id: UID,
    name: String,
}

/// A helper struct used during initialization of the display metadata.
/// - This struct has the `drop` ability, which allows it to be destroyed once it serves its purpose.
public struct DEMO_BEAR has drop {}

// === Public Functions ===

/// Function to initialize the display metadata for `DemoBear`.
/// - Takes an instance of `DEMO_BEAR` and sets up display fields for `DemoBear` objects.
/// - Creates a `Display` object with predefined fields like name, image URL, and description.
/// - Transfers ownership of the `Display` object back to the sender.
///
/// Parameters:
/// - `otw`: A `DEMO_BEAR` object, used to claim publishing rights.
/// - `ctx`: Transaction context, used to manage the current transaction state.
fun init(otw: DEMO_BEAR, ctx: &mut TxContext) {
    // Claim publishing rights for the display metadata using the `DEMO_BEAR` object.
    let publisher = package::claim(otw, ctx);

    // Define the metadata keys (fields) for `DemoBear`.
    let keys = vector[
        utf8(b"name"),         // Dynamic placeholder for the bear's name.
        utf8(b"image_url"),    // URL to an image representing the bear.
        utf8(b"description"),  // Static description for all DemoBears.
    ];

    // Define the corresponding values for the metadata keys.
    let values = vector[
        utf8(b"{name}"), // Placeholder `{name}` will be replaced with the bear's actual name.
        utf8(
            b"https://images.unsplash.com/photo-1589656966895-2f33e7653819?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cG9sYXIlMjBiZWFyfGVufDB8fDB8fHww"
        ),              // Hardcoded URL to a happy bear image.
        utf8(b"The greatest figure for demos"), // Description shared by all DemoBears.
    ];

    // Create a new `Display` object linking the metadata to the `DemoBear` type.
    let mut display = display::new_with_fields<DemoBear>(
        &publisher, // Publisher address from the claimed package.
        keys,       // Metadata keys defined above.
        values,     // Metadata values defined above.
        ctx,        // Transaction context for committing changes.
    );

    // Commit the first version of the display metadata to make it available.
    display::update_version(&mut display);

    // Transfer ownership of the `Display` and publisher objects back to the transaction sender.
    sui::transfer::public_transfer(display, ctx.sender());
    sui::transfer::public_transfer(publisher, ctx.sender());
}

/// Function to create a new `DemoBear` object.
///
/// Parameters:
/// - `name`: The name of the bear, passed as a `String`.
/// - `ctx`: Transaction context, used to manage the current transaction state.
///
/// Returns:
/// - A new `DemoBear` object with the specified name.
public fun new(name: String, ctx: &mut TxContext): DemoBear {
    // Create and return a new `DemoBear` object with a unique ID and the provided name.
    DemoBear {
        id: object::new(ctx), // Generate a unique ID for the bear.
        name: name,           // Assign the given name to the bear.
    }
}
