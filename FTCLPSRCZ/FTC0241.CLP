/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FT Outgoing Payments by Destination')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Funds Transfer Module                           */
/*                                                                   */
/*       FTC0241  - CL Component to Control FT0241                   */
/*                - Outgoing Payment Summary By Destination          */
/*                - Selection By Originating Branch                  */
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
/*       Prev Amend No. 074791             Date 19Jul94              */
/*                      S01494             Date 25May94              */
/*                      051416             DATE  26FEB93             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*           NEW SOURCE BASED ON FTC0240 FOR REL10                   */
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       074791 - Override spool file name if in regular payments    */
/*                mode. Fixed during development fo S01494.          */
/*       S01494 - BLI Funds Transfer Enhancements                    */
/*       051416 - ADD PARAMETER &TYPE ON CALL TO FT0239              */
/*********************************************************************/
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
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RNTP) TYPE(*CHAR) LEN(7)                /*S01494*/
/**/
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&TYPE) VALUE(%SST(&RPARM 3 1))
 
             IF (&TYPE = '3') THEN(DO)
             CHGVAR     VAR(&TYPE) VALUE(' ')
             ENDDO
/**/
/** Check if LDA data area exists and create it if not **/
/**/
        CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
        MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                   DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                   VALUE(' ') TEXT('Midas SD LOCAL +
                   DATA AREA EQUIVALENT') AUT(*USE))
 
 
/* CLEAR EXTRACT FILE OTPAYEX */
             CLRPFM     FILE(OTPAYEX)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('REPORT IS ALREADY IN USE PLEASE WAIT +
                          AND TRY AGAIN') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(WAIT)
             ENDDO
 
/**/                                                                 /*S01494*/
/** If run type is Regular Payment (FTM2509) then override the */    /*S01494*/
/** database file OTPAYDD to RPPAYOB */                              /*S01494*/
/**/                                                                 /*S01494*/
             CHGVAR     VAR(&RNTP) VALUE(%SST(&RPARM 4 7))           /*S01494*/
             IF         COND(&RNTP *EQ 'FTM2509') THEN(DO)           /*S01494*/
                OVRDBF     FILE(OTPAYDD) TOFILE(RPPAYOB)             /*S01494*/
             ENDDO                                                   /*S01494*/
 
/*GENERATE OTPAYEX EXTRACT RECORDS*/
 
/*051416*/
/*           CALL PGM(FT0239)                    */
/************CALL PGM(FT0239) PARM(&TYPE)                         */ /*S01494*/
             CALL PGM(FT0239) PARM(&TYPE &RNTP)                      /*S01494*/
/*051416*/
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
             SNDPGMMSG  MSG('CALL TO EXTRACT PROGRAM FT0239 FROM +
                          FTC0240 ENDED IN ERROR') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             GOTO       CMDLBL(END)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO CMDLBL(END))
 
/**/
/** Set up overrides **/
/**/
             IF         COND(&TYPE *EQ ' ') THEN(DO)
             IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(OTPALLOB) POSITION(*KEY 1 *N &RENT)
             OPNDBF     FILE(OTPALLOB) OPTION(*INP)
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(OTPALLOB) +
                          POSITION(*END))
             ENDDO
             ENDDO
 
             IF         COND(&TYPE *EQ '1') THEN(DO)
             IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(OTPALLOB) TOFILE(OTPAUTOB) +
                          POSITION(*KEY 1 *N &RENT)
             OPNDBF     FILE(OTPALLOB) OPTION(*INP)
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(OTPALLOB) +
                          POSITION(*END))
             ENDDO
             ELSE       CMD(OVRDBF FILE(OTPALLOB) TOFILE(OTPAUTOB))
             ENDDO
 
             IF         COND(&TYPE *EQ '2') THEN(DO)
             IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(OTPALLOB) TOFILE(OTPUNTOB) +
                          POSITION(*KEY 1 *N &RENT)
             OPNDBF     FILE(OTPALLOB) OPTION(*INP)
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(OTPALLOB) +
                          POSITION(*END))
             ENDDO
             ELSE       CMD(OVRDBF FILE(OTPALLOB) TOFILE(OTPUNTOB))
             ENDDO
 
/**/                                                                 /*074791*/
/** If run type is Regular Payment (FTM2509) then override the */    /*074791*/
/** printer files  */                                                /*074791*/
/**/                                                                 /*074791*/
             IF         COND(&RNTP *EQ 'FTM2509') THEN(DO)           /*074791*/
                OVRPRTF    FILE(FT0241P1) SPLFNAME(FT0243P1)         /*074791*/
                OVRPRTF    FILE(FT0241AU) SPLFNAME(FT0243AU)         /*074791*/
             ENDDO                                                   /*074791*/
/**/
/** Call Program **/
/**/
/*******CALL       PGM(FT0241) PARM(&TYPE &RSEQ &RLEV &RENT)      */ /*S01494*/
        CALL       PGM(FT0241) PARM(&TYPE &RSEQ &RLEV &RENT &RNTP)   /*S01494*/
 
             CLOF       OPNID(OTPALLOB)
             MONMSG     MSGID(CPF4520)
/**/
/**  Delete overrides  */
/**/
 
                        DLTOVR     FILE(OTPALLOB)
                        MONMSG     MSGID(CPF9841)
                        DLTOVR     FILE(FT0241P1)                    /*074791*/
                        MONMSG     MSGID(CPF9841)                    /*074791*/
                        DLTOVR     FILE(FT0241AU)                    /*074791*/
                        MONMSG     MSGID(CPF9841)                    /*074791*/
 
/**/
/** Check for database errors trapped by the program **/
/**/
END:
        IF   COND(%SWITCH(XXXXXX11))   THEN(DO)
             RTVDTAARA   DTAARA(LDA (134 50))   RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                    TOPGMQ(*EXT) TOMSGQ(MOPERQ)
        ENDDO
 
/**/
/** Check for file control errors trapped by the program **/
/**/
        IF   COND(%SWITCH(XXXXXX01))   THEN(DO)
                     SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ)
        ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* CLEAR EXTRACT FILE OTPAYEX */
             CLRPFM     FILE(OTPAYEX)
WAIT:
/**/
             ENDPGM
