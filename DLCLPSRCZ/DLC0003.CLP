/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Citydealer Retrieve Journal Info File')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0003 - Citydealer Retrieve Journal Information File.     */
/*                                                                   */
/*       Function: This program will be called by DLC0002 whenever   */
/*                 a new journal receiver has been attached for      */
/*                 JRN/ICJRN.  The file PF/DLCDJNPD will be          */
/*                 received to set up the new from receiver range    */
/*                 and from entry sequence number.                   */
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
/*       Prev Amend No. CCM002 *CREATE     DATE 04SEP95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCM002 - Midas/Citydealer Interface (Phases V and VI)       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&JSEQNO &NXTJRC)
/**/
             DCL        VAR(&JSEQNO) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NXTJRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCLF       FILE(DLCDJNPD)
/**/
/*    Global monitor message                                         */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             OVRDBF     FILE(DLCDJNPD) SHARE(*NO)
             DLYJOB     DLY(30)
/**/
/*    Open and receive database file PF/DLCDJNPD                     */
/**/
             OPNDBF     FILE(DLCDJNPD) OPTION(*INP)
             RCVF
/**/
/*    Set the Journal sequence number and the                        */
/*       Next journal receiver from file.                            */
/**/
             CHGVAR     VAR(&JSEQNO) VALUE(&JOSEQN)
             CHGVAR     VAR(&NXTJRC) VALUE(&JNRCN)
/**/
/*    Close database file PF/DLCDJNPD                                */
/**/
             CLOF       OPNID(DLCDJNPD)
             GOTO       CMDLBL(END)
/**/
/*    Abnormal termination - batch job                               */
/**/
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Citydealer Retrieve Journal Information +
                          File ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
