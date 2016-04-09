/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL APPC connection to Citydealer for rates')    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Dealing Module                                  */
/*                                                                   */
/*       DLC0001 - APPC connection program to Citydealer             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Last Amend No. 130547             Date 06Jan00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK009             Date 09Jul99              */
/*                      085931             Date 07APR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       130547 - CREATE DATA AREA LDA , OVERRIDE SDCURRL1 TO        */
/*                SHARE(*NO)                                         */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       085931 - Update of Spot Rate on Currencies Files.           */
/*                 Check for message on MSTATUS                      */
/*                                                                   */
/*********************************************************************/
     PGM
/* Copyright statement definition                               */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
 
/* Declare variables :                                          */
 
             DCL        VAR(&MEM)      TYPE(*CHAR) LEN(44)
 
/* Global message monitor :                                     */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**  Copyright statement definition - at runtime                   */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/** START OF 130547 **/
             OVRDBF     FILE(SDCURRL1) SHARE(*NO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('MIDAS¦ABS SD Local data area')
             MONMSG     MSGID(CPF1023)
/** END OF 130547 **/
 
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
             MONMSG     MSGID(CPF8351)
 
/**  Send message to MSTATUS **/
             SNDMSG     MSG(MIDAS) TOMSGQ(MSTATUS)
 
/**  Allocate Dataarea to avoid program to run more than once      */
 
             SNDPGMMSG  MSG('Starting APPC Communication to +
                          Citydealer for Rates') TOMSGQ(MRUNQ)
             ALCOBJ     OBJ((DL0001 *DTAARA *EXCL)) WAIT(1)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Midas APPC communication to Citydealer +
                          already started') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(END)
             ENDDO
 
/**  Start communication program                                   */
 
             TRCICF     SET(*ON)
             CALL       PGM(DL0001)
 
/*   Print Trace and deallocate *DTAARA                            */
             TRCICF     SET(*OFF)
             DLCOBJ     OBJ((DL0001 *DTAARA *EXCL))
 
/**  Remove message from MSTATUS **/
             CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)
             RCVMSG     MSGQ(MSTATUS) RMV(*YES)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
                                                                      /*E85931*/
             ROLLBACK                                                 /*E85931*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E85931*/
                                                                      /*E85931*/
             SNDPGMMSG  MSG('Midas APPC Communication program to +
                          Citydealer ended abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:        ENDPGM
