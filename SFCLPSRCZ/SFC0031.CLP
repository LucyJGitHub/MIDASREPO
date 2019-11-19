/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SF Account codes audit report')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Security Profile Facility                           */
/*                                                                   */
/*       SFC0031 - Account Codes Authorities Audit Report            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD053230           Date 12Nov19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      MD027362           Date 19Aug14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 15Sep99              */
/*                      CGL008             Date 01Mar99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD053230 - Failed component SFC0031.                        */
/*       MD046248 - Finastra Rebranding                              */
/*       MD027362 - BFTC Input cycle report not generated            */
/*       CPK009 - Remove calls to CB0150 and CB0160 as they are      */
/*                incorrectly coded and unecessary.                  */
/*       CGL008 - Security on Journal Entry Input                    */
/*                                                                   */
/*********************************************************************/

             PGM        PARM(&PARM &RSEQ &RLEV &RENT)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&ACCD) TYPE(*CHAR) LEN(4)                */                 /*MD027362*/
             DCL        VAR(&ACCD) TYPE(*CHAR) LEN(10)                                  /*MD027362*/

             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Set up Environment. */

             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&CNAM) VALUE(%SUBSTRING(&PARM 1 10))
             CHGVAR     VAR(&MODE) VALUE(%SUBSTRING(&PARM 11 1))
             CHGVAR     VAR(&CSEQ) VALUE(&RSEQ)
/**********       CALL      PGM(CB0160) PARM(&CNAM &CSEQ &STAT) **/                       /*CPK009*/
/**********       IF        COND(&STAT *EQ 'N') THEN(DO)        **/                       /*CPK009*/
/**********       CALL      PGM(CB0150) PARM(&CNAM &CSEQ &STAT) **/                       /*CPK009*/
/**********       ENDDO                                         **/                       /*CPK009*/

/* Create LDA if not present */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO

             CHGDTAARA  DTAARA(LDA (134 50)) VALUE(' ')


/* Reset external switches */
             CHGJOB     SWS(XXXXXXXX)

                                                                                        /*MD053230*/
/** Call SQL program to synchronize SFACAUPD with SDACODPD           */                 /*MD053230*/
                                                                                        /*MD053230*/
             CALL       PGM(SF0031U)                                                    /*MD053230*/
                                                                                        /*MD053230*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                /*MD053230*/
             GOTO       CMDLBL(ABNOR)                                                   /*MD053230*/
             ENDDO                                                                      /*MD053230*/
                                                                                        /*MD053230*/
/* Call program */

             CALL       PGM(SF0031) PARM(&ACCD &RSEQ &MODE)

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO

/**********       CHGVAR     VAR(&STAT) VALUE('N')               **/                      /*CPK009*/
/**********       CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT) **/                      /*CPK009*/

             GOTO       CMDLBL(END)

/* Error processing */
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
/*           ROLLBACK     */
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000)

             ENDPGM
