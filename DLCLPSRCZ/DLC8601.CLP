/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('MIDAS - Spot date a/c keys generation.**new*')        */
/*********************************************************************/
/*                                                                   */
/*        Midas - Dealing Module                                     */
/*                                                                   */
/*       DLC8601 - Spot Date Account Keys Generation - Control       */
/*                                                                   */
/*       Function:  This program controls the generation of the      */
/*                  Spot Date Account Keys Generation.               */
/*                                                                   */
/*       Called By: COB dependencies                                 */
/*                                                                   */
/*       (c) Finastra International Limited 2021                     */
/*                                                                   */
/*       Last Amend No. CDL086             Date 04May21              */
/*       Prev Amend No. AR1014698 *Create  Date 04May21              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*  CDL086 - Portuguese FX Revaluation Extensions                    */
/*           Upgrade to FM 2.1 2021.A                          */
/*           Upgrade with fix AR1014698.                             */
/*  AR1014698 - Reconciliation issues with Midas R4 system           */
/*              (Child: AR1014700). Upgrade LBM001 as part of        */
/*              CDL086.                                              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
             PGM        PARM(&CNAM &CSEQ)
/*                                                                   */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2021')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LDA)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(55)
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(2)
/*                                                                   */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                        CMDLBL(CLERROR))
/*                                                                   */
             SNDMSG     MSG('DLC8601 - Spot Date Account Key +
                          Generation') TOMSGQ(MRUNQ MOPERQ)
/*                                                                   */
/** Setup DPLIB name.                                                */
/*                                                                   */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR     VAR(&DPLIB) VALUE(&PRE *CAT  'DPLIB')
/*                                                                   */
/** Clear job switches and relevant files                            */
/*                                                                   */
             CHGJOB     SWS(XXXXXX00)
             CLRPFM     FILE(DLSPKYPH)
             CLRPFM     FILE(DLSPKYPP)
             CLRPFM     FILE(DLSPKYPT)
/*                                                                   */
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/*                                                                   */
        IF         COND(&STAT *EQ 'N') THEN(DO)
/*                                                                   */
/** This is NOT a restart - copy master to back up files             */
/*                                                                   */
               CPYF    FROMFILE(DEALSDX0) TOFILE(&DPLIB/XDEALSDX0) +
                        MBROPT(*ADD) CRTFILE(*YES)

               CHGVAR     VAR(&STAT) VALUE('Y')
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
               ENDDO
        ELSE CMD(DO)
/*                                                                   */
/** This is a restart - copy back up files to master for re-try of co*/
/*                                                                   */
               CPYF    FROMFILE(XDEALSDX0) TOFILE(DEALSDX0) +
                        MBROPT(*REPLACE)
               MONMSG  MSGID(CPF2817 CPF2869) EXEC(CLRPFM +
                        FILE(DEALSDX0))
        ENDDO
/*                                                                   */
/** Call SPOT DATE ACCOUNT KEYS GENERATION PROGRAM.                  */
/*                                                                   */
             CALL       PGM(DL8601)
/*                                                                   */
/** If program completes normally the program, delete back up file   */
/*                                                                   */
 NOERROR:    IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
               CHGVAR     VAR(&STAT) VALUE('N')
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
               DLTF       FILE(XDEALSX0)
               MONMSG     MSGID(CPF0000)
               GOTO       END
             ENDDO
/*                                                                   */
/** If program has a DATABASE ERROR (U7 AND U8 is on)                */
/*                                                                   */
 DBERROR:    IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&LDA)
               SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&LDA) +
                          TOMSGQ(MRUNQ MOPERQ)
               CHGVAR   VAR(&MEM) VALUE('DLC8601 - JOB TERMINATED, +
                        DATABASE IN ERROR')
               SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
               GOTO       CMDLBL(END)
             ENDDO
/*                                                                   */
/** If program has an execution time error (U7 OR U8 is on)          */
/*                                                                   */
 CLERROR:    CHGJOB     SWS(XXXXXXX1)
             CHGVAR     VAR(&MEM) VALUE('DLC8601 - REQUEST FAILED. +
                        PROGRAM EXECUTION TIME ERROR.')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)
/*                                                                   */
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
