//
//  PopoverData.swift
//  TestTaskPecode
//
//  Created by Petro on 24.09.2021.
//

import Foundation
import UIKit


class PopoverData {
    
    let popover1data: [String] = [Category.business.rawValue, Category.entertainment.rawValue, Category.general.rawValue, Category.health.rawValue, Category.science.rawValue]
    
    let popover2data: [String] =  [Country.ae.rawValue, Country.ar.rawValue, Country.at.rawValue, Country.au.rawValue, Country.be.rawValue, Country.bg.rawValue, Country.br.rawValue, Country.ca.rawValue, Country.ch.rawValue, Country.cn.rawValue, Country.co.rawValue, Country.cu.rawValue, Country.cz.rawValue, Country.de.rawValue, Country.eg.rawValue, Country.fr.rawValue, Country.gb.rawValue, Country.gr.rawValue, Country.hk.rawValue, Country.hu.rawValue, Country.id.rawValue, Country.ie.rawValue, Country.il.rawValue, Country.`in`.rawValue, Country.it.rawValue, Country.jp.rawValue, Country.kr.rawValue, Country.lt.rawValue, Country.lv.rawValue, Country.ma.rawValue, Country.mx.rawValue, Country.my.rawValue, Country.ng.rawValue, Country.nl.rawValue, Country.no.rawValue, Country.nz.rawValue, Country.ph.rawValue, Country.pl.rawValue, Country.pt.rawValue, Country.ro.rawValue, Country.rs.rawValue, Country.ru.rawValue, Country.sa.rawValue, Country.se.rawValue, Country.sg.rawValue, Country.si.rawValue, Country.sk.rawValue, Country.th.rawValue, Country.tr.rawValue, Country.tw.rawValue, Country.ua.rawValue, Country.us.rawValue, Country.ve.rawValue, Country.za.rawValue]
    
    let popover3Data: [String] = ["Sourse"]
    
    func givePopoverData(popoverName: String) -> [String] {
        switch popoverName {
        case "showPopover1":
            return popover1data

        case "showPopover2":
            return popover2data

        case "showPopover3":
            return popover3Data

        default:
            print("Do not have such popover")
        }
        return [" "]
    }
}
