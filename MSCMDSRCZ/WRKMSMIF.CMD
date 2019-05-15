/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(MS6130P)    VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI    HLPPNLGRP(WRKMSMIF)   HLPID(*CMD)                           */
/*EXI *  TEXT('Midas MS Work with Midas/Swift Meridian interface')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Midas SWIFT                                         */
/*                                                                   */
/*       WRKMSMIF - Work with Midas/Swift Meridian interface         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG5980            Date 30Mar05              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSW025             Date 15Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CSW017 *Create     Date 11Feb99              */
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG5980 - Change parameter condition for automatic start.   */
/*       CSW025 - Midas Message Manager                              */
/*       CSW017 - Midas/SWIFT Meridian interface                     */
/*                                                                   */
/*********************************************************************/
 
             CMD        PROMPT('Wk with MidasSwift Meridian IF')
 
/**********  PARM       KWD(OPERATION) TYPE(*CHAR) LEN(9) RSTD(*YES) + */                 /*CSW025*/
/**********               VALUES(*STARTUP *SHUTDOWN) MIN(1) +          */                 /*CSW025*/
/**********               PROMPT('Operation')                          */                 /*CSW025*/
             PARM       KWD(OPERATION) TYPE(*CHAR) LEN(9) RSTD(*YES) +
                          VALUES(*STARTUP *SHUTDOWN *EOD) MIN(1) +
                          PROMPT('Operation')                                             /*CSW025*/
 
             PARM       KWD(MCID) TYPE(*CHAR) LEN(26) RSTD(*NO) +
                          DFT(*ALL) SPCVAL((*ALL)) MIN(0) +
                          CASE(*MIXED) PROMPT('Midas/Swift +
                          Meridian Comms ID')
 
             PARM       KWD(MODE) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          DFT(*MANUAL) VALUES(*AUTO *MANUAL) MIN(0) +
                          PMTCTL(PMT1) PROMPT('Mode')
 
             PARM       KWD(TYPE) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          DFT(*SYNCH) VALUES(*SYNCH *ASYNCH) MIN(0) +
                          PMTCTL(PMT2) PROMPT('Type')
 
/********** PMT1:       PMTCTL     CTL(OPERATION) COND((*EQ *STARTUP)) */                /*BUG5980*/
 PMT1:       PMTCTL     CTL(OPERATION) COND((*EQ *STARTUP) (*EQ +
                          *EOD)) NBRTRUE(*EQ 1)                                          /*BUG5980*/
 
 PMT2:       PMTCTL     CTL(OPERATION) COND((*EQ *SHUTDOWN))
