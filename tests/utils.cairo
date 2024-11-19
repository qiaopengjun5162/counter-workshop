use starknet::{ContractAddress};
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};

pub fn deploy_contract(initial_value: u32) -> ContractAddress {
    let contract = declare("counter_contract").unwrap().contract_class();
    let constructor_args = array![initial_value.into()];
    let (contract_address, _) = contract.deploy(@constructor_args).unwrap();
    contract_address
}
