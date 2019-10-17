/*STD    CLPBASE                                                     */
/*EXI    TEXT('MIDAS LE PDP Prepare Available Balance files')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC004652 - Midas LE PDP Prepare Available Balance Files    */
/*                                                                   */
/*       (c) Finastra International Limited 2017                     */
/*                                                                   */
/*       Last Amend No. MD54253            Date 20Sep19              */
/*       Prev Amend No. MD36674  *Create   Date 24Nov15              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD54253 - PDCL X generation despite sufficient balance on   */
/*                 settlement account                                */
/*       MD36674 - Prepare files required in LE000495 prior to       */
/*                 the running of LEC000495 (CLE164)                 */
/*               - Applied for MD-48954                              */
/*                                                                   */
/*********************************************************************/

      PGM    PARM(&CNAM &CSEQ)

/* Declare variables                                                 */

      DCL    VAR(&CNAM) TYPE(*CHAR) LEN(10)
      DCL    VAR(&CSEQ) TYPE(*DEC) LEN(5)
      DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2017')

      MONMSG     MSGID(CPF0000 MCH0000 RPG0000)

      CHGJOB     SWS(00000000)

/** Main Processing Control */
      SNDPGMMSG  MSG('Midas LE PDP Prepare Available Balance +
                                Files') TOMSGQ(MRUNQ)

/** Prepare Tables */
      CLRPFM     FILE(GLACPMPD)

      CLRPFM     FILE(GLACRMPD)

/********CPYF       FROMFILE(ACPO1) TOFILE(GLACPMPD) +               */                 /*MD054253*/
/********MBROPT(*REPLACE) RCDFMT(APOSTPDF)                           */                 /*MD054253*/

      IF         COND(&CSEQ *EQ 1) THEN(DO)                                             /*MD054253*/
         CPYF       FROMFILE(ACPO1) TOFILE(GLACPMPD) MBROPT(*REPLACE) +
                      RCDFMT(APOSTPDF)                                                  /*MD054253*/
         MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(GLACPMPD)) +
                                                                                        /*MD054253*/
      ENDDO                                                                             /*MD054253*/
      ELSE       CMD(DO)                                                                /*MD054253*/
         CPYF       FROMFILE(ACPO5) TOFILE(GLACPMPD) MBROPT(*REPLACE) +
                      RCDFMT(APOSTPDF)                                                  /*MD054253*/
         MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(GLACPMPD))
      ENDDO                                                                             /*MD054253*/
/*****MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +        */                 /*MD054253*/
/**********      FILE(GLACPMPD))                                     */                 /*MD054253*/

      CPYF       FROMFILE(GLACPOL0) TOFILE(GLACPMPD) +
                   MBROPT(*ADD) RCDFMT(APOSTPDF)

      CPYF       FROMFILE(ACPO1) TOFILE(GLACRMPD) +
                   MBROPT(*REPLACE) RCDFMT(APOSTRAF)
      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                 FILE(GLACRMPD))

      CLRPFM     FILE(LETMPLTD)

      CLRPFM     FILE(LETBL1TD)

      CLRPFM     FILE(LEXTRCTD)

      GOTO       CMDLBL(ENDPGM)

ERROR:
      CHGJOB     SWS(XXXXXX11)
      SNDPGMMSG  MSG('Job terminated.') TOMSGQ(MOPERQ MRUNQ)

ENDPGM:
      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                   Finastra International Limited')

      ENDPGM
