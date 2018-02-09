/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FT Debit and credit advices - input cycle')     */
/*********************************************************************/
/*                                                                   */
/*       Midas      FUNDS TRANSFER MODULE                            */
/*                                                                   */
/*       FTC0561  - CL COMPONENT TO CONTROL FT0560                   */
/*                  DR/CR ADVICES GENERATION - INPUT CYCLE           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1060743          Date 26Nov12              */
/*                      CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG4835            Date 25Oct03              */
/*                      CPK016             Date 04Jun03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      S01408            DATE  15NOV96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1060743 - All HATS input initial screen appears a         */
/*                   confirmation of NWDC processing                 */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       BUG4835- Stop this program from looping.                    */
/*       CPK016 - Externalise STRCMTCTL code for ease of later       */
/*                upgrade.                                           */
/*       CCB009 - Journal files throughout close of business         */
/*                - Renamed journal TEMPJRN to JFTC0561.             */
/*                - Renamed journal receiver FTTEMPRCV to JFTC0561.  */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*    S01408 - Addition of core hook FTC0561002                      */
/*             Addition of core hook FTC0561001                      */
/*                                                                   */
/*********************************************************************/
 
     PGM        PARM(&RSEQ &RLEV &RENT)
 
     DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
     DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
     DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
     DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
     DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
     DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6)
     DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
/****DCL***     VAR(&PHASE) TYPE(*CHAR) LEN(1)                                         */ /*CCB020*/
     DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(4)                                            /*CCB020*/
     DCL        VAR(&CMTRTN) TYPE(*CHAR) LEN(10)                                          /*CPK016*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)                         */ /*CCB009 CCB020*/
/**********  DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)                        */ /*CCB009 CCB020*/
/*/COPY WNCPYSRC,FTC0561001                                          */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/**/
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +                         */ /*CCB020*/
/**********               'CCB009' &AOFMT)                                      */ /*CCB009 CCB020*/
        CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
        MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                   DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                   VALUE(' ') TEXT('Midas SD LOCAL +
                   DATA AREA EQUIVALENT') AUT(*USE))
/**/
/*IF C.O.B JOURNAL FILES TO TEMPORARY JOURNAL*/
/**/
/**********  RTVDTAARA  DTAARA(MPHAS *ALL) RTNVAR(&PHASE)                              */ /*CCB020*/
/**********  CALL       PGM(CBC000001) PARM(&MPHAS)                             /*CCB020 AR1060743*/
             CALL       PGM(CBC001001) PARM(&MPHAS)                                    /*AR1060743*/
/**********  IF         COND(&PHASE *EQ 'C') THEN(DO)                                  */ /*CCB020*/
             IF         COND(&MPHAS *EQ '*YES') THEN(DO)                                  /*CCB020*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PREFIX) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&JLIB) VALUE(&PREFIX *CAT 'JLIB')
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                    */ /*CCB009 CCB020*/
/**********  CRTJRNRCV  JRNRCV(&JLIB/FTTEMPRCV)                                           /*CCB009*/
/**********  CRTJRNRCV  JRNRCV(&JLIB/JRFTC0561)                                 */ /*CCB009 CCB020*/
/**********  CRTJRN     JRN(&JLIB/FTTEMPJRN) JRNRCV(FTTEMPRCV)                            /*CCB009*/
/**********  CRTJRN     JRN(&JLIB/JFTC0561) JRNRCV(JRFTC0561)                   */ /*CCB009 CCB020*/
/**********  STRJRNPF   FILE(CQCODDD CQCOCDD CQPADDD CQPACDD INPAYDD +                    /*CCB009*/
/**********               OTPAYDD) JRN(FTTEMPJRN) IMAGES(*BOTH) +                         /*CCB009*/
/**********               OMTJRNE(*OPNCLO)                                                /*CCB009*/
/**********  STRJRNPF   FILE(CQCODDD CQCOCDD CQPADDD CQPACDD INPAYDD +                 */ /*CCB020*/
/**********               OTPAYDD) JRN(JFTC0561) IMAGES(*BOTH) +                       */ /*CCB020*/
/**********               OMTJRNE(*OPNCLO)                                      */ /*CCB009 CCB020*/
/**********  ENDDO                                                              */ /*CCB009 CCB020*/
             ENDDO
 /**/
/**/
     CHGJOB     SWS(XXXXXX00)
/**/
/** set up override **/
/**/
          IF COND((&RENT *NE 'ALL') *AND (&RENT *NE '   ')) THEN(DO)
             OVRDBF     FILE(ADVGENB) TOFILE(ADVGENO) POSITION(*KEY +
                          1 *N &RENT)
             OPNDBF     FILE(ADVGENB) OPTION(*INP)
             MONMSG     MSGID(CPF4125) EXEC(OVRDBF FILE(ADVGENB) +
                          POSITION(*END))
             ENDDO
             ELSE       CMD(OVRDBF FILE(ADVGENB) TOFILE(ADVGENO))
/**/
/*/COPY WNCPYSRC,FTC0561002                                          */
/* Start commitment control */                                                            /*CPK016*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CPK009*/
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) + */                /*CPK009*/ /*CPK016*/
/**********               CMTSCOPE(*JOB)                     */                /*CPK009*/ /*CPK016*/
             CALL       PGM(SCCMTCTL) PARM('S' &CMTRTN)                                   /*CPK016*/
/**/
/** call program & monitor for untrapped errors **/
/**/
/**/                                                                  /*S01408*/
/*******WNCPYSRC,FTC0580001 ********************************S01408*/  /*BUG4835*/
/**/                                                                  /*S01408*/
     CALL       PGM(FT0560) PARM('O' &RSEQ &RLEV &RENT)
/**/                                                                  /*S01408*/
/*******WNCPYSRC,FTC0580002 *********************************S01408*/ /*BUG4835*/
/**/                                                                  /*S01408*/
     MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(DO)
                ROLLBACK
                SNDPGMMSG  MSG('Update failed, advices +
                           not produced.') TOPGMQ(*EXT)
                GOTO END
     ENDDO
/**/
/*/COPY WNCPYSRC,FTC0561003                                          */
/** check for database errors trapped by program **/
/**/
     IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                             TOPGMQ(*EXT)  TOMSGQ(MOPERQ)
     ENDDO
             GOTO       CMDLBL(END)
/**/
 ERROR:      ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('DEBIT/CREDIT ADVICES PROGRAM TERMINATED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:
/**/
/** delete overrides **/
/**/
             DLTOVR     FILE(ADVGENB)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                  /*BUG4835*/
/*IF C.O.B */
/**/
/**********  IF         COND(&PHASE *EQ 'C') THEN(DO)                                  */ /*CCB020*/
             IF         COND(&MPHAS *EQ '*YES') THEN(DO)                                  /*CCB020*/
             CLOF       OPNID(ADVGENB)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CLOF       OPNID(ADVGENO)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                    */ /*CCB009 CCB020*/
/**********  CHGJOB     INQMSGRPY(*DFT)                                                */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
/**********  ENDJRNPF   FILE(*ALL) JRN(&JLIB/FTTEMPJRN)                                   /*CCB009*/
/**********  ENDJRNPF   FILE(*ALL) JRN(&JLIB/JFTC0651)                          */ /*CCB009 CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
/**********  DLTJRN     JRN(&JLIB/FTTEMPJRN)                                              /*CCB009*/
/**********  DLTJRN     JRN(&JLIB/JFTC0561)                                     */ /*CCB009 CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
/**********  DLTJRNRCV  JRNRCV(&JLIB/FTTEMPRCV) */                                        /*CCB009*/
/**********  DLTJRNRCV  JRNRCV(&JLIB/JRFTC0561)                                           /*CCB009*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
/**********  CHGJOB     INQMSGRPY(*RQD)                                                */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
/**********  ENDDO                                                              */ /*CCB009 CCB020*/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
        ENDPGM
