/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Change of Customer/Portfolio Currency')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC6310 - PM Change of Customer/Portfolio Base Currency     */
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
/*       Prev Amend No. CPM005             Date 19Jun96              */
/*                      S01124             Date 25May94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase II                           */
/*                Focus Group Changes Upgraded to DBA                */
/*       S01124 - PBFG/1 - Change of Customer/Portfolio Currency     */
/*                                                                   */
/*********************************************************************/
             PGM
 
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)              */ /*CPM005*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*CPM005*/
             DCL        VAR(&NOREPLY) TYPE(*CHAR) LEN(1)              /*CPM005*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CPM005*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*CPM005*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*CPM005*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CPM005*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* GLOBAL ERROR MONITOR TRAP                                */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
 
             CHGJOB     SWS(00000000)
 
/**/                                                                  /*CPM005*/
/* Determine if SAR CPM004 is switched ON */                          /*CPM005*/
/**/                                                                  /*CPM005*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CPM005*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CPM005*/
             CHGVAR     VAR(&SAR) VALUE('CPM004')                     /*CPM005*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*CPM005*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CPM005*/
/**/                                                                  /*CPM005*/
/*  Call SCC0010 to inform user that PGM cannot be run */             /*CPM005*/
/**/                                                                  /*CPM005*/
               CHGDTAARA  DTAARA(MIDASMSG (251 60)) VALUE('Bank +
                            Portfolio SAR (CPM004) is ACTIVE! +
                            Program cannot be run')                   /*CPM005*/
               CALL       PGM(SCC0010) PARM('PMC0000' 'ENTER' +
                            &NOREPLY)                                 /*CPM005*/
               GOTO       CMDLBL(END)                                 /*CPM005*/
             ENDDO                                                    /*CPM005*/
/**/                                                                  /*CPM005*/
             CALL       PGM(PM6310)
 
/*  DATABASE ERRORS, IF U7 & U8 ON  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/************RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)          */ /*CPM005*/
/************SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) +            */ /*CPM005*/
/************             MSGDTA(&MEM) TOMSGQ(MOPERQ MRUNQ)        */ /*CPM005*/
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)             /*CPM005*/
             SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
             ENDDO
             GOTO       CMDLBL(END)
 
/*  ERROR IN CL PROGRAM  */
 ENDTAG:     DMPCLPGM
/*END********ENDPGM                                                */ /*CPM005*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*CPM005*/
