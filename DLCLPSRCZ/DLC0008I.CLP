/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Citydealer setup journalling info at inst')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0008I - Citydealer Set Up Journalling Information File   */
/*                  at Installation of Switchable Feature CCM002.    */
/*                                                                   */
/*       Function: This program will be called during installation   */
/*                 of the switchable feature CCM002 from SCOFMENU.   */
/*                 It may only be called in Input Cycle with         */
/*                 journalling active, so the feature should not be  */
/*                 installed at any other time.                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 099851 *CREATE     DATE 21FEB96              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       099851 - Created to allow correct installation of the       */
/*                Midas/Citydealer interface (Phases V & VI)         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)
/**/
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&JSEQNO) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NXTJRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*/COPY WNCPYSRC,DLC0008I01                                          */
/**/
/*    Global monitor message                                         */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*/COPY WNCPYSRC,DLC0008I02                                          */
/**/
/* Mode 1 - First call */
/**/
             IF         COND(&PMODE *EQ '1') THEN(DO)
/**/
             SNDPGMMSG  MSG('DLC0008I - Citydealer Installation, set +
                          up Journalling Info') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
/** Retrieve Journal Entry.                                          */
/**/
/*/COPY WNCPYSRC,DLC0008I03                                          */
             RTVJRNE    JRN(ICJRN) FROMENT(*LAST) TOENT(*LAST) +
                          SEARCH(*DESCEND) RTNSEQNBR(&JSEQNO) +
                          RTNRCV(&NXTJRC)
/*/COPY WNCPYSRC,DLC0008I04                                          */
/**/
/*    Call LE, FT, RE & NT Extract File Update program to set up     */
/*    journalling information file PF/DLCDJNPD                       */
/**/
             CALL       PGM(DL0008) PARM(&NXTJRC &JSEQNO)
/**/
/*    Database error processing                                      */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOMSGQ(MOPERQ MRUNQ)
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
             ENDDO
/**/
             GOTO       CMDLBL(END)
             ENDDO
/**/
/* Mode 2 - Second call */
/**/
             IF         COND(&PMODE *EQ '2') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
/**/
/* Mode 3 - Deletion */
/**/
             IF         COND(&PMODE *EQ '3') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,DLC0008I05                                          */
             GOTO       CMDLBL(END)
/**/
/*   Abnormal termination                                            */
/**/
 ABNOR:
/*/COPY WNCPYSRC,DLC0008I06                                          */
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Citydealer Installation, set up of +
                          Journalling Info ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,DLC0008I07                                          */
             ENDPGM
