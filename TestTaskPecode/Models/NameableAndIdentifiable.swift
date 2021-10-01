//
//  NameableAndIdentifiable.swift
//  TestTaskPecode
//
//  Created by Petro on 28.09.2021.
//

import Foundation

protocol NameableAndIdentifiable {
    var id: String {get}
    var name: String {get}
}

extension Source : NameableAndIdentifiable {}

extension Category : NameableAndIdentifiable {
    var id: String {
        return rawValue
    }
    
    var name: String {
        return rawValue.capitalized
    }
}

extension Country : NameableAndIdentifiable {
    var id: String {
        return rawValue
    }
    
    var name: String {
        switch self {
        case .ae: return "Arab Emirates"
        case .ar: return "Argentina"
        case .at: return "Austria"
        case .au: return ""
        case .be: return ""
        case .bg: return ""
        case .br: return ""
        case .ca: return ""
        case .ch: return ""
        case .cn: return ""
        case .co: return ""
        case .cu: return ""
        case .cz: return ""
        case .de: return ""
        case .eg: return ""
        case .fr: return ""
        case .gb: return ""
        case .gr: return ""
        case .hk: return ""
        case .hu: return ""
        case .id: return ""
        case .ie: return ""
        case .il: return ""
        case .in: return ""
        case .it: return ""
        case .jp: return ""
        case .kr: return ""
        case .lt: return ""
        case .lv: return ""
        case .ma: return ""
        case .mx: return ""
        case .my: return ""
        case .ng: return ""
        case .nl: return ""
        case .no: return ""
        case .nz: return ""
        case .ph: return ""
        case .pl: return ""
        case .pt: return ""
        case .ro: return ""
        case .rs: return ""
        case .ru: return ""
        case .sa: return ""
        case .se: return ""
        case .sg: return ""
        case .si: return ""
        case .sk: return ""
        case .th: return ""
        case .tr: return ""
        case .tw: return ""
        case .ua: return "Ukraine"
        case .us: return "America"
        case .ve: return ""
        case .za: return ""
        }
    }
}
