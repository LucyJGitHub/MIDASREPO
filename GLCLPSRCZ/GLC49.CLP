/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Generated Entries Report')                   */
/********************************************************************/
/*                                                                  */
/*       Midas     General Ledger Module                        */
/*                                                                  */
/*       GLC49 - GENERATED ENTRIES REPORT                           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.03 --------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408                  DATE  06AUG96       */
/*       PREV AMEND NO. E40440                  DATE  21MAY92       */
/*                      BHF798                  DATE  25APR91       */
/*                      S01244                  DATE  29JUN90       */
/*                      S01194                  DATE  16/03/89      */
/*                      S01117                  DATE  02/03/89      */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       S01408  -  Core Hook GLC49END Added                        */
/*       E40440  -  DOES NOT WORK CORRECTLY FOR SINGLE BRANCH       */
/*       BHF798  -  FOR OPNDBF ADD CLOF .                           */
/*       S01244  -  GENERATED ENTRIES REPORT RESEQUENCED            */
/*       S01194  -  NEW STANDING DATA                               */
/*       S01117  -  MULTIBRANCHING                                  */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM*/                                                    /*S01117*/
             PGM  (&RSEQ &RLEV &RENT)                                 /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/*/COPY WNCPYSRC,GLC49001                                            */
/**/
             SNDPGMMSG  MSG('GLC49 - Generated Entries Report') +
                          TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
/*********** OVRDBF     FILE(TABLE) TOFILE(TABGL)*/                   /*S01194*/
/*********** CALL       PGM(GL0490)                             */    /*S01117*/
/**/                                                                  /*S01244*/
/*           IF         COND(&RLEV *EQ 'S') THEN(DO)       S01244E40440*/
             IF         COND((&RLEV *EQ 'S') *OR (&RLEV *EQ ' ')) +
                          THEN(DO) /* E40440 */
/**/                                                                  /*S01244*/
                        CALL       PGM(GL0491) PARM(&RSEQ)            /*S01244*/
                        ENDDO                                         /*S01244*/
/**/                                                                  /*S01244*/
             ELSE       CMD(DO)                                       /*S01244*/
/**/                                                                  /*S01244*/
             IF         COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                          THEN(DO)                                    /*S01117*/
                          OVRDBF FILE(SGE) POSITION(*KEY 1 +
                          APOSTPDF &RENT)                             /*S01117*/
                          OPNDBF FILE(SGE) OPTION(*ALL)               /*S01117*/
                          MONMSG MSGID(CPF0000) EXEC(DO)              /*S01117*/
                          DLTOVR FILE(SGE)                            /*S01117*/
                          ENDDO                                       /*S01117*/
                          ENDDO                                       /*S01117*/
             CALL       PGM(GL0490) PARM(&RSEQ &RENT)                 /*S01117*/
             DLTOVR     FILE(SGE)                                     /*S01117*/
             MONMSG     MSGID(CPF9841)                                /*S01117*/
/*/COPY WNCPYSRC,GLC49002                                            */
/**/                                                                  /*S01244*/
                          ENDDO                                       /*S01244*/
/**/                                                                  /*S01244*/
/*********** DLTOVR     FILE(TABLE)*/                                 /*S01194*/
/**/                                                                  /*BHF798*/
             CLOF       OPNID(SGE)                                    /*BHF798*/
                          MONMSG MSGID(CPF0000)                       /*BHF798*/
/**/
/*********** IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)*/            /*S01194*/
             IF         COND(%SWITCH(XXXXXX01)) THEN(DO)              /*S01194*/
/**/
                SNDPGMMSG  MSG('FILE OUT OF BALANCE - SGE') TOMSGQ(MOPERQ)
                SNDPGMMSG  MSG('FILE OUT OF BALANCE - SGE') TOMSGQ(MRUNQ)
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*                                                                 */ /*S01408*/
/*/COPY WNCPYSRC,GLC49END                                          */ /*S01408*/
/*                                                                 */ /*S01408*/
             ENDPGM
