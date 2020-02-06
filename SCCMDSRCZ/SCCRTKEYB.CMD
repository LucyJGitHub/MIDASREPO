/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(SCC3200)    VLDCKR(SCC3100)    MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(SCCRTKEYB)      HLPID(*CMD)                       */
/*EXI *  TEXT('Midas SC Command to insert new SAR details')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCCRTKEYB- Generate new or update old core                  */
/*                  switchable feature and details.                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC010             Date 10Jun99              */
/*                      CSC007             Date 08May98              */
/*                      CSC005  *CREATE    Date 08May98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC010 - Change default to 'B' for Maintained by and        */
/*                disallow use of 'C' for non core changes           */
/*       CSC007 - Allow switchable features flagged as 'B' for       */
/*                'at Beta site' to be switched on.                  */
/*       CSC005 - New suite of programs and files to permit          */
/*                insertion of switchable features via passwords.    */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Switchable Features Add/Update')
 
             PARM       KWD(SARN) TYPE(*NAME) LEN(6) MIN(1) +
                          FULL(*YES) PROMPT('Switchable Feature ID:')
 
             PARM       KWD(PASS) TYPE(*CHAR) LEN(16) MIN(1) +
                          PROMPT('Password:')
 
             PARM       KWD(NEWD) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PROMPT('Insert new +
                          details')
 
             PARM       KWD(SARD) TYPE(*CHAR) LEN(50) MIN(0) +
                          CASE(*MIXED) PMTCTL(PMT1) +
                          PROMPT('Description')
 
             PARM       KWD(PRIM) TYPE(*NAME) LEN(2) MIN(0) +
                          FULL(*YES) PMTCTL(PMT1) +
                          PROMPT('Primary Module')
 
             PARM       KWD(CEMI) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N) PMTCTL(PMT1) +
                          PROMPT('Complex')
 
             PARM       KWD(WRELL) TYPE(*CHAR) LEN(5) RSTD(*YES) +
                          VALUES(R10.4 R10.5 DBAR1 DBAR2 DBAR3) +
                          MIN(0) PMTCTL(PMT1) PROMPT('Release level')
 
             PARM       KWD(WIREL) TYPE(*CHAR) LEN(2) MIN(0) +
                          PMTCTL(PMT1) PROMPT('Interim Release Level')
 
             PARM       KWD(CLVL) TYPE(*CHAR) LEN(4) MIN(0) +
                          PMTCTL(PMT1) PROMPT('Collection +
                          Level')
 
/************PARM*******KWD(RSTS) TYPE(*CHAR) LEN(1) RSTD(*YES) +     /*CSC007*/
/*************************DFT(R) VALUES(R A W) MIN(0) +               /*CSC007*/
/*************************PMTCTL(PMT1) PROMPT('Release Status')       /*CSC007*/
 
             PARM       KWD(RSTS) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(R) VALUES(R A W B) MIN(0) +
                          PMTCTL(PMT1) PROMPT('Release Status')       /*CSC007*/
 
             PARM       KWD(DFLT) TYPE(*CHAR) LEN(3) RSTD(*YES) +
                          DFT(OFF) VALUES(OFF ON) MIN(0)  +
                          PMTCTL(PMT1) PROMPT('Default')
 
/*Start CSC010                                                    */
/******      PARM       KWD(MNTB) TYPE(*CHAR) LEN(1)  +           */
/******                   DFT(C) MIN(0)  +                        */
/******                   PMTCTL(PMT1) PROMPT('Maintained By')    */
 
             PARM       KWD(MNTB) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(B) VALUES(A B D E F G H I J K L M N O +
                          P Q R S T U V W X Y Z) MIN(0) +
                          PMTCTL(PMT1) PROMPT('Maintained By')
/*End CSC010                                                      */
 
/*Start CSC007                                                    */
/*********** PARM       KWD(CHRG) TYPE(*CHAR) LEN(1) RSTD(*YES) + */
/*************************DFT(N) VALUES(Y N) MIN(0) +             */
/*************************PMTCTL(PMT1) PROMPT('Chargeable')       */
/*End CSC007                                                      */
 
             PARM       KWD(CHRG) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(N) VALUES(Y N C) MIN(0) +
                          PMTCTL(PMT1) PROMPT('Chargeable')
 
             PARM       KWD(FLRN) TYPE(*CHAR) LEN(35) +
                          DFT('ABSENG/DBAR4') MIN(0) PMTCTL(PMT1) +
                          PROMPT('Folder')
 
/************PARM*******KWD(DOCN) TYPE(*CHAR) LEN(11) +               /*CSC007*/
/*************************MIN(0)  +                                   /*CSC007*/
/*************************PMTCTL(PMT1) PROMPT('Document')             /*CSC007*/
                                                                      /*CSC007*/
             PARM       KWD(DOCN) TYPE(*CHAR) LEN(11) +
                          DFT(FEATURES.C) MIN(0) PMTCTL(PMT1) +
                          PROMPT('Document')                          /*CSC007*/
 
/************PARM*******KWD(HELP) TYPE(*CHAR) LEN(8)  +               /*CSC007*/
/*************************MIN(0)  +                                   /*CSC007*/
/*************************PMTCTL(PMT1) PROMPT('Help Tag')             /*CSC007*/
 
             PARM       KWD(HELP) TYPE(*CHAR) LEN(8) DFT(NODETAIL) +
                          MIN(0) PMTCTL(PMT1) PROMPT('Help Tag')      /*CSC007*/
 
             PARM       KWD(LOCAT) TYPE(*CHAR) LEN(1) RTNVAL(*NO) +
                          CONSTANT(B) RSTD(*NO)
 
 PMT1:       PMTCTL     CTL(NEWD) COND((*EQ Y))
 
