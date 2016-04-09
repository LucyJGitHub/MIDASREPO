/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT INCOMING PAYMENTS BY SENDER (ORBR)')         */
/********************************************************************/
/*                                                                  */
/*       Midas     - FUNDS TRANSFER MODULE                      */
/*                                                                  */
/*       FTC0251  - CL COMPONENT TO CONTROL FT0250                  */
/*                - INCOMING PAYMENT SUMMARY BY SENDER              */
/*                - SELECTION BY ORIGINATING BRANCH                 */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO.                   DATE  DDMMMYY1            */
/*                                                                  */
/*********************************************************************/
/*           NEW SOURCE BASED ON FTC0250 FOR REL10                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
        PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
        DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
        DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
        DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
        DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
        DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
        DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
        DCL        VAR(&BORO) TYPE(*CHAR) LEN(1) VALUE('O')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/**/
        CHGJOB     SWS(XXXXXX00)
        CHGVAR     VAR(&TYPE) VALUE(%SST(&RPARM 3 1))
 
        IF (&TYPE = '3') THEN(DO)
        CHGVAR     VAR(&TYPE) VALUE(' ')
        ENDDO
/**/
/** CHECK IF LDA DATA AREA EXISTS AND CREATE IT IF NOT **/
/**/
        CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
        MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                   DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                   VALUE(' ') TEXT('Midas SD LOCAL +
                   DATA AREA EQUIVALENT') AUT(*USE))
 
 
/* CLEAR EXTRACT FILE INPAYEX */
             CLRPFM     FILE(INPAYEX)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('REPORT IS ALREADY IN USE PLEASE WAIT +
                          AND TRY AGAIN') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(WAIT)
             ENDDO
 
 
/*GENERATE INPAYEX EXTRACT RECORDS*/
 
             CALL PGM(FT0249) PARM(&TYPE)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('CALL TO EXTRACT PROGRAM FT0249 FROM +
                          FTC0251 ENDED IN ERROR') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(END)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(END))
 
 
/**/
/**  SET UP OVER RIDES **/
/**/
         IF         COND(&TYPE *EQ ' ') THEN(DO)
         IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
           OVRDBF     FILE(INPASABB) TOFILE(INPASAOB) POSITION(*KEY +
                          1 *N &RENT)
           OPNDBF     FILE(INPASABB) OPTION(*INP)
           MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(INPASABB) +
                           POSITION(*END))
         ENDDO
         ELSE       CMD(OVRDBF FILE(INPASABB) TOFILE(INPASAOB))
         ENDDO
 
         IF         COND(&TYPE *EQ '1') THEN(DO)
         IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
           OVRDBF     FILE(INPASABB) TOFILE(INPAUTOB) POSITION(*KEY +
                          1 *N &RENT)
           OPNDBF     FILE(INPASABB) OPTION(*INP)
           MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(INPASABB) +
                          POSITION(*END))
         ENDDO
         ELSE       CMD(OVRDBF FILE(INPASABB) TOFILE(INPAUTOB))
         ENDDO
 
         IF         COND(&TYPE *EQ '2') THEN(DO)
         IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
           OVRDBF     FILE(INPASABB) TOFILE(INPNASOB) +
                          POSITION(*KEY 1 *N &RENT)
           OPNDBF     FILE(INPASABB) OPTION(*INP)
           MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(INPASABB) +
                          POSITION(*END))
         ENDDO
         ELSE       CMD(OVRDBF FILE(INPASABB) TOFILE(INPNASOB))
         ENDDO
 
/**/
/** CALL PROGRAM **/
/**/
             CALL  PGM(FT0250) PARM(&RSEQ &RLEV &RENT &TYPE &BORO)
 
/**/
/** DELETE OVERIDES IF PRESENT **/
/**/
        CLOF       OPNID(INPASABB)
        MONMSG     MSGID(CPF4520)
        DLTOVR     FILE(INPASABB)
        MONMSG     MSGID(CPF9841)
 
/**/
/** CHECK FOR DATABASE ERRORS TRAPPED BY THE PROGRAM **/
/**/
 
END:
 
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                    TOPGMQ(*EXT) TOMSGQ(MOPERQ)
        ENDDO
 
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* CLEAR EXTRACT FILE INPAYEX */
             CLRPFM     FILE(INPAYEX)
 
 
WAIT:
 
 
             ENDPGM
