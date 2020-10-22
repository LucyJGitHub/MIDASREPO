/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Control of Test Messages for CGPNARMSG')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       CGTSTCTL - Control of Test Messages for CGPNARMSG           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD054980           Date 05Oct20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      184382             Date 29Sep90              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      109175             Date 16Feb98              */
/*                      101582             DATE 06Jan98              */
/*                      101709             DATE 29APR97              */
/*                      089745             DATE 27JUN95              */
/*                      S01522             DATE 29DEC94              */
/*                                                                   */
/*********************************************************************/
/*   NOTE- When inserting code for a new message, please check for   */
/*         any changes required in CLP/CGADDCTL as well.             */
/*********************************************************************/
/*                                                                   */
/*       MD054980 - Retail Teller narratives not multilanguage       */
/*                - Add 00970/980/990                                */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       184382 - Missing info on message utility                    */
/*       109175 - Add 00880/881/890/900/910/920/930/940/950/960      */
/*       101582 - Check for presence of test msgq CGMSG              */
/*       101709 - Incorrect message id for Retail a/c posting        */
/*                narrative.  New one added to message file.         */
/*       089745 - Add test for GB01001 for FT                        */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MNCUST &MNBRCA)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

             DCL        VAR(&MNTRNO) TYPE(*CHAR) LEN(16) +
                          VALUE('330123')
             DCL        VAR(&MNSDTE) TYPE(*CHAR) LEN(7) +
                          VALUE('01JAN94')
             DCL        VAR(&MNDUED) TYPE(*CHAR) LEN(7) +
                          VALUE('02JAN94')
             DCL        VAR(&MNMODI) TYPE(*CHAR) LEN(2) VALUE('GL')
             DCL        VAR(&MNBRCA) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MNCUST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MNCYCD) TYPE(*CHAR) LEN(3) +
                          VALUE('GBP')
/**********  DCL        VAR(&MNACCD) TYPE(*CHAR) LEN(4) +
                          VALUE('5132')                                                   /*CGL029*/
             DCL        VAR(&MNACCD) TYPE(*CHAR) LEN(10) +
                          VALUE('0000005132')                                             /*CGL029*/
             DCL        VAR(&MNACSQ) TYPE(*CHAR) LEN(2) +
                          VALUE('01')
             DCL        VAR(&MNCRNM) TYPE(*CHAR) LEN(20) +
                          VALUE('CUSTOMER REPORT NAME')
             DCL        VAR(&MNOAMT) TYPE(*CHAR) LEN(21) +
                          VALUE('9.99')
             DCL        VAR(&MNIRTE) TYPE(*CHAR) LEN(14) +
                          VALUE('    8.125     ')
             DCL        VAR(&MNYRTE) TYPE(*CHAR) LEN(14) +
                          VALUE('    9.5       ')
             DCL        VAR(&MNRODL) TYPE(*CHAR) LEN(6) +
                          VALUE('000002')
             DCL        VAR(&MNFCDE) TYPE(*CHAR) LEN(2) +
                          VALUE('99')
             DCL        VAR(&MNSECN) TYPE(*CHAR) LEN(10) +
                          VALUE('BONDS     ')
             DCL        VAR(&MNFFIN) TYPE(*CHAR) LEN(20) +
                          VALUE('FINANCIAL INSTRUMENT')
             DCL        VAR(&MNFFMK) TYPE(*CHAR) LEN(2) +
                          VALUE('NW')
             DCL        VAR(&MNFFIC) TYPE(*CHAR) LEN(3) +
                          VALUE('INS')
             DCL        VAR(&MNFFPD) TYPE(*CHAR) LEN(5) +
                          VALUE('JAN94')
             DCL        VAR(&MNFFPC) TYPE(*CHAR) LEN(1) +
                          VALUE('P')
             DCL        VAR(&MNFFSP) TYPE(*CHAR) LEN(15) +
                          VALUE('     12.25     ')
             DCL        VAR(&MNBOKC) TYPE(*CHAR) LEN(2) +
                          VALUE('BC')
             DCL        VAR(&MNCHNB) TYPE(*CHAR) LEN(10) +
                          VALUE('0000008501')
             DCL        VAR(&MNRACN) TYPE(*CHAR) LEN(10) +
                          VALUE('9000019700')
             DCL        VAR(&MNNARR) TYPE(*CHAR) LEN(30) +
                          VALUE('ORIGINAL POSTING NARRATIVE')
             DCL        VAR(&MNASOC) TYPE(*CHAR) LEN(6) +
                          VALUE('100016')
             DCL        VAR(&MNOCCY) TYPE(*CHAR) LEN(10) +
                          VALUE('FRF')
/**********  DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(244)                                 /*CGL029*/
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(250)                                 /*CGL029*/

   /*    */
             CHGVAR     VAR(%SST(&MSGDTA 01 16)) VALUE(&MNTRNO)
             CHGVAR     VAR(%SST(&MSGDTA 17 07)) VALUE(&MNSDTE)
             CHGVAR     VAR(%SST(&MSGDTA 24 07)) VALUE(&MNDUED)
             CHGVAR     VAR(%SST(&MSGDTA 31 02)) VALUE(&MNMODI)
             CHGVAR     VAR(%SST(&MSGDTA 33 03)) VALUE(&MNBRCA)
             CHGVAR     VAR(%SST(&MSGDTA 36 06)) VALUE(&MNCUST)
             CHGVAR     VAR(%SST(&MSGDTA 42 03)) VALUE(&MNCYCD)
/**********  CHGVAR     VAR(%SST(&MSGDTA 45 04)) VALUE(&MNACCD)                           /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 49 02)) VALUE(&MNACSQ)                           /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 51 20)) VALUE(&MNCRNM)                           /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 71 21)) VALUE(&MNOAMT)                           /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 92 14)) VALUE(&MNIRTE)                           /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 106 14)) VALUE(&MNYRTE)                          /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 120 06)) VALUE(&MNRODL)                          /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 126 02)) VALUE(&MNFCDE)                          /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 128 10)) VALUE(&MNSECN)                          /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 138 20)) VALUE(&MNFFIN)                          /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 158 02)) VALUE(&MNFFMK)                          /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 160 03)) VALUE(&MNFFIC)                          /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 163 05)) VALUE(&MNFFPD)                          /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 168 01)) VALUE(&MNFFPC)                          /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 169 15)) VALUE(&MNFFSP)                          /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 184 02)) VALUE(&MNBOKC)                          /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 186 10)) VALUE(&MNCHNB)                          /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 196 10)) VALUE(&MNRACN)                          /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 206 30)) VALUE(&MNNARR)                          /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 236  6)) VALUE(&MNASOC)                          /*CGL029*/
/**********  CHGVAR     VAR(%SST(&MSGDTA 242  3)) VALUE(&MNOCCY)                          /*CGL029*/
                                                                                          /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 45 10)) VALUE(&MNACCD)                           /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 55 02)) VALUE(&MNACSQ)                           /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 57 20)) VALUE(&MNCRNM)                           /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 77 21)) VALUE(&MNOAMT)                           /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 98 14)) VALUE(&MNIRTE)                           /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 112 14)) VALUE(&MNYRTE)                          /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 126 06)) VALUE(&MNRODL)                          /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 132 02)) VALUE(&MNFCDE)                          /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 134 10)) VALUE(&MNSECN)                          /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 144 20)) VALUE(&MNFFIN)                          /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 164 02)) VALUE(&MNFFMK)                          /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 166 03)) VALUE(&MNFFIC)                          /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 169 05)) VALUE(&MNFFPD)                          /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 174 01)) VALUE(&MNFFPC)                          /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 175 15)) VALUE(&MNFFSP)                          /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 190 02)) VALUE(&MNBOKC)                          /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 192 10)) VALUE(&MNCHNB)                          /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 202 10)) VALUE(&MNRACN)                          /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 212 30)) VALUE(&MNNARR)                          /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 242  6)) VALUE(&MNASOC)                          /*CGL029*/
             CHGVAR     VAR(%SST(&MSGDTA 248  3)) VALUE(&MNOCCY)                          /*CGL029*/
   /*    */
             CHKOBJ     OBJ(CGMSG) OBJTYPE(*MSGQ)                     /*101582*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*101582*/
             CRTMSGQ    MSGQ(QTEMP/CGMSG)                             /*101582*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*101582*/
             ENDDO                                                    /*101582*/
             CLRMSGQ    MSGQ(QTEMP/CGMSG)                             /*184382*/
   /*    */
             CALL       PGM(CGTSTMSG) PARM('GB00000' &MSGDTA)
             CALL       PGM(CGTSTMSG) PARM('GB00010' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00020' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00030' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00031' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00032' &MSGDTA)
             CALL       PGM(CGTSTMSG) PARM('GB00040' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00050' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00060' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00070' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00080' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00090' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00100' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00110' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00120' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00130' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00140' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00150' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00160' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00170' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00180' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00190' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00191' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00192' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00200' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00201' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00202' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00210' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00211' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00212' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00220' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00221' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00222' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00230' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00231' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00232' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00240' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00241' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00242' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00250' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00251' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00252' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00260' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00261' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00262' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00270' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00271' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00272' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00280' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00281' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00282' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00290' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00291' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00292' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00300' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00301' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00302' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00310' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00311' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00312' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00320' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00321' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00322' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00330' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00331' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00332' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00340' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00341' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00342' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00350' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00351' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00352' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00360' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00361' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00362' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00370' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00371' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00372' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00375' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00380' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00390' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00400' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00410' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00420' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00430' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00440' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00450' &MSGDTA )        /*184382*/
             CALL       PGM(CGTSTMSG) PARM('GB00460' &MSGDTA )        /*184382*/
             CALL       PGM(CGTSTMSG) PARM('GB00470' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00480' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00490' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00500' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00580' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00590' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00660' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00661' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00680' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00681' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00690' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00700' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00710' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00720' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00730' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00731' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00740' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00741' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00750' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00752' &MSGDTA )        /*101709*/
             CALL       PGM(CGTSTMSG) PARM('GB00840' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00850' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00860' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00870' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB00880' &MSGDTA )        /*109175*/
             CALL       PGM(CGTSTMSG) PARM('GB00881' &MSGDTA )        /*109175*/
             CALL       PGM(CGTSTMSG) PARM('GB00890' &MSGDTA )        /*109175*/
             CALL       PGM(CGTSTMSG) PARM('GB00900' &MSGDTA )        /*109175*/
             CALL       PGM(CGTSTMSG) PARM('GB00910' &MSGDTA )        /*109175*/
             CALL       PGM(CGTSTMSG) PARM('GB00920' &MSGDTA )        /*109175*/
             CALL       PGM(CGTSTMSG) PARM('GB00930' &MSGDTA )        /*109175*/
             CALL       PGM(CGTSTMSG) PARM('GB00940' &MSGDTA )        /*109175*/
             CALL       PGM(CGTSTMSG) PARM('GB00950' &MSGDTA )        /*109175*/
             CALL       PGM(CGTSTMSG) PARM('GB00960' &MSGDTA )        /*109175*/
             CALL       PGM(CGTSTMSG) PARM('GB00970' &MSGDTA )        /*MD054980*/
             CALL       PGM(CGTSTMSG) PARM('GB00980' &MSGDTA )        /*MD054980*/
             CALL       PGM(CGTSTMSG) PARM('GB00990' &MSGDTA )        /*MD054980*/
             CALL       PGM(CGTSTMSG) PARM('GB01000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB01001' &MSGDTA )        /*089745*/
             CALL       PGM(CGTSTMSG) PARM('GB02000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB03000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB04000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB05000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB06000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB07000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB08000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB09000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB10000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB11000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB11001' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB13000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB15000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB17000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB21000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB22000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB23000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB24000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB25000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB26000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB27000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB28000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB29000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB30000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB31000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB32000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB33000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB34000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB35000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB36000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB44000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB45000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB46000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB47000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB48000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB49000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB50000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GB51000' &MSGDTA )        /*184382*/
             CALL       PGM(CGTSTMSG) PARM('GBFA000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GBFB000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GBFC000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GBFD000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GBFE000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GBFF000' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GBF1001' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GBF2001' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GBF3001' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GBF4001' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GBF5001' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GBF6001' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GBF7001' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GBF8001' &MSGDTA )
             CALL       PGM(CGTSTMSG) PARM('GBF9001' &MSGDTA )

ENDCLPGM:    CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DSPMSG     MSGQ(QTEMP/CGMSG)                             /*101582*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*101582*/

             ENDPGM
