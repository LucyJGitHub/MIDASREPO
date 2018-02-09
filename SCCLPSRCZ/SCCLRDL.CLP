/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Clear dealing daily files')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCCLRDL - CLEAR DAILY DEALING FILES                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 193885             Date 17Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CDE002             Date 23May00              */
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CCM003             Date 02Feb01              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      110929             Date 23Jan98              */
/*                      073175             DATE 21NOV97              */
/*                      CSW005             DATE 15JAN97              */
/*                      CCM002             DATE 04SEP95              */
/*                      S01408             DATE 03AUG95              */
/*                      S01378             DATE 24APR92              */
/*                      S01343             DATE 15AUG91              */
/*                      S01117             DATE 24APR90              */
/*                      S01196             DATE 19FEB90              */
/*                      S01194             DATE 19FEB90              */
/*                      S01147             DATE 14/01/88             */
/*                      S01119             DATE 19/06/87             */
/*                      E80674             DATE 09/10/86             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   193885 - Trap message CPF7301 generated when trying to remove   */
/*            a member from an empty HISTEAA file so that the        */
/*            program could continue without MSGW interference.      */
/*   CDE002 - Data Export - CCRM Revenue Analysis                   */
/*   CCM003 - Download of Cashflows from Midas to City Dealer.      */
/*            Clear PF/DLETVTPD.                                    */
/*   110929 - When ICI is run more than once, DL0280 FOOBs in       */
/*            DLC10. This is due to files DAPCLH & DAPCLJ already   */
/*            being cleared on ICI. LF/DAMSX uses PF/DAPCLJ         */
/*            which is being used by DL0280.                        */
/*   073175 - Remove excess mambers from Interest History Enquiry    */
/*            print file.                                            */
/*   CSW005 - Clear DLOLCFPD and DLOLACPD as these are not           */
/*            now automatically cleared each time DL2900 is run.     */
/*            MT34n and MT36n Message Generation for FRA/IRS         */
/*   CCM002 - Midas/Citydealer Interface (Phases V and VI).          */
/*            This is to clear the Citydealer Interface              */
/*            daily files.                                           */
/*   S01408 - Core hook added, SCCLRDLMPS, SCCLRDLMPE.               */
/*   S01378 - Facilitates the partial sale of a parcel               */
/*            of negotiable instruments which have been              */
/*            previously input to the system as a single             */
/*            transaction. When NAB is entered the parcel            */
/*            size defines the number of parcels it may be           */
/*            split into for selling. The parcel size on the         */
/*            NAS defines the number of parcels being sold           */
/*            by the transaction. (was MOF53). Must clear            */
/*            parcelled N/A's sold extract files.                    */
/*   S01343 - SC/RR/SD MODULE RENAME PROJECT.                        */
/*            - SCCLRDL RENAMED FROM SDCLRDL                         */
/*   S01117 - MULTI BRANCHING (TO ALLOW INPUT CYCLE EVENTS REPORT)   */
/*   S01194 - NEW STANDING DATA FILES                                */
/*   S01196 - REMOVAL OF LETTERS OF CREDIT FILES                     */
/*   S01147 - RELEASE 22                                             */
/*   S01119 - DEALING FILE CHANGES FOR FRA/IRS                       */
/*   E80674 - FILES GEDL2PD AND GEDL2ZZ SHOULD BE CLEARED            */
/*                                                                   */
/*********************************************************************/
             PGM
/*                                                                            */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Finastra International Limited +
                          2001')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SCCLRDLMPS                                           /*S01408*/
                                                                      /*S01408*/
/*                                                                            */
/* CLEAR DEALING DAILY FILES                                                  */
             SNDPGMMSG  TOMSGQ(MRUNQ) MSG('Clear Dealing Daily Files')
/*                                                                            */
/*                                                                /* S01196 */
/*           CLRPFM     FILE(BVNTXEA)           */
/*           CLRPFM     FILE(BVNTXED)           */
/*           CLRPFM     FILE(BVNTXEZ)           */
/*           CLRPFM     FILE(NSXBCED)           */
/*                                                                /* S01196 */
             CLRPFM     FILE(IREXDHH)
             CLRPFM     FILE(IREXDIC)
             CLRPFM     FILE(IREXDZZ)
             CLRPFM     FILE(IREXRHH)
             CLRPFM     FILE(IREXRIC)
             CLRPFM     FILE(IREXRZZ)
             CLRPFM     FILE(DAMEXDH)
             CLRPFM     FILE(DAMEXDI)
             CLRPFM     FILE(DAMEXDJ)
             CLRPFM     FILE(DAUPDHH)
             CLRPFM     FILE(DAUPDDI)
             CLRPFM     FILE(DAUPDDJ)
             CLRPFM     FILE(DAINDHH)
             CLRPFM     FILE(DAINDDL)
             CLRPFM     FILE(DAINDEX)
             CLRPFM     FILE(NDAMSDH)
             CLRPFM     FILE(NDAMSDI)
             CLRPFM     FILE(NDAMSDJ)
             CLRPFM     FILE(DLINDHH)
             CLRPFM     FILE(DLINDDM)
             CLRPFM     FILE(DLINDZX)
/*           CLRPFM     FILE(NEWDLDA)           */                    /*S01147*/
/*           CLRPFM     FILE(NEWDLDB)           */                    /*S01147*/
/*           CLRPFM     FILE(NEWDLDC)           */                    /*S01147*/
/*           CLRPFM     FILE(NEWDLDD)           */                    /*S01147*/
/*           CLRPFM     FILE(NEWDLDE)           */                    /*S01147*/
/*           CLRPFM     FILE(NEWDLDF)           */                    /*S01147*/
/*           CLRPFM     FILE(NEWDLDG)           */          /*S01119*  *S01147*/
             CLRPFM     FILE(DLUPDDA)
             CLRPFM     FILE(DLUPDDB)
             CLRPFM     FILE(DLUPDDC)
             CLRPFM     FILE(DLUPDDD)
             CLRPFM     FILE(DLUPDDE)
             CLRPFM     FILE(DLUPDDF)
             CLRPFM     FILE(DLUPDDG)                                 /*S01119*/
             CLRPFM     FILE(ACCEXAN)
             CLRPFM     FILE(ACCEXAO)
             CLRPFM     FILE(ACCEXAP)
             CLRPFM     FILE(DKEYSHH)
             CLRPFM     FILE(DKEYSDP)
             CLRPFM     FILE(DKEYSZZ)
             CLRPFM     FILE(GESRHH)
             CLRPFM     FILE(GESRPD)
             CLRPFM     FILE(GESRZZ)
             CLRPFM     FILE(GEDLHH)
             CLRPFM     FILE(GEDLPD)
             CLRPFM     FILE(GEDLZZ)
             CLRPFM     FILE(GEDL2PD)                                 /*E80674*/
             CLRPFM     FILE(GEDL2ZZ)                                 /*E80674*/
             CLRPFM     FILE(GEFRHH)
             CLRPFM     FILE(GEFRPD)
             CLRPFM     FILE(GEFRZZ)
/*           CLRPFM     FILE(EVNTXEC)                              */ /*S01117*/
/*           CLRPFM     FILE(EVNTXED)                              */ /*S01117*/
 /*          CLRPFM     FILE(EVNTXZZ)                              */ /*S01117*/
 /*          CLRPFM     FILE(CEVNXCC)                              */ /*S01117*/
 /*          CLRPFM     FILE(CEVNXZZ)                              */ /*S01117*/
             CLRPFM     FILE(EVLXCEC)
             CLRPFM     FILE(EVLXCED)
             CLRPFM     FILE(EVLXCEE)
             CLRPFM     FILE(EVLXCEG)
             CLRPFM     FILE(EVDCMHH)
             CLRPFM     FILE(EVDCMED)
             CLRPFM     FILE(EVDCMZZ)
/*                                                                /* S01194 */
/*           CLRPFM     FILE(LIMRVHH)           */
/*           CLRPFM     FILE(LIMRVLH)           */
/*           CLRPFM     FILE(LIMRVZZ)           */
/*                                                                /* S01194 */
             CLRPFM     FILE(NOSEXEC)
             CLRPFM     FILE(NOSEXED)
             CLRPFM     FILE(NOSEXCC)
             CLRPFM     FILE(NOSEXZZ)
             CLRPFM     FILE(PRONTHH)
             CLRPFM     FILE(PRONTPP)
             CLRPFM     FILE(PRONTZX)
             CLRPFM     FILE(DAMBRDH)
             CLRPFM     FILE(DAMBRDI)
             CLRPFM     FILE(DAMBRDJ)
 
/*           CLRPFM     FILE(DAPCLH)                       /*S01378*/ /*110929*/
/*           CLRPFM     FILE(DAPCLI)                       /*S01378*/ /*110929*/
/*           CLRPFM     FILE(DAPCLJ)                       /*S01378*/ /*110929*/
/**/                                                                  /*CCM002*/
/*    Clear the Citydealer Interface Daily files.                     /*CCM002*/
/**/                                                                  /*CCM002*/
             CLRPFM     FILE(DLCDNCPD)                                /*CCM002*/
             CLRPFM     FILE(DLCDCGPD)                                /*CCM002*/
             CLRPFM     FILE(DLCDAUPD)                                /*CCM002*/
             CLRPFM     FILE(DLOLACPD)                                /*CSW005*/
             CLRPFM     FILE(DLOLCFPD)                                /*CSW005*/
             CLRPFM     FILE(DEFAAKPD)                                /*CDE002*/
                                                                      /*073175*/
/*** Remove added enquiry members from interest history          ***/ /*073175*/
/*** extract file                                                ***/ /*073175*/
             RMVM       FILE(HISTEAA) MBR(*ALL)                       /*073175*/
             MONMSG     MSGID(CPF7301)                                /*193885*/
             ADDPFM     FILE(HISTEAA) MBR(HISTEAA)                    /*073175*/
                                                                      /*S01408*/
             CLRPFM     FILE(DLETVTPD)                                /*CCM003*/
/*/COPY WNCPYSRC,SCCLRDLMPE                                           /*S01408*/
                                                                      /*S01408*/
/*                                                                            */
             SNDPGMMSG  TOMSGQ(MRUNQ) MSG('Dealing Daily Files Cleared')
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM     /* END CL PGM */
