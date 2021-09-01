/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI *  TEXT('EXTRACT LOAN IQ TRANSACTIONS')                       */
/********************************************************************/
/*                                                                  */
/*     Midas - European Reporting - Italy                           */
/*                                                                  */
/*     ERC0600LIQ - EXTRACT LOAN IQ TRANSACTIONS                    */
/*                                                                  */
/*     (C) Copyright Misys 2008                                     */
/*                                                                  */
/*     Last Amend No. MD058100           Date 20May21               */
/*     Prev Amend No. LUC139             Date 04Jan21               */
/*                    MBV006   *Create   Date 06Jun08               */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD058100 - Rollup of additional BoI onsite fixes at FbMidas*/
/*       LUC139 - Upgrade UCI Italian Returns                       */
/*       MBV006 - Extract Loan IQ transactions                      */
/*                                                                  */
/********************************************************************/

             PGM

             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ERDLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)

             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))

             CHGJOB     SWS(00000000)

             SNDMSG     MSG('ERC0600LIQ - Extract Loan IQ +
                          Transactions') TOMSGQ(MRUNQ)

/* Retrieve Midas sbs prefix and build library names                 */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&ERDLIB) VALUE(&PREFIX *CAT 'ERDLIB')
             CHGVAR     VAR(&DILIB) VALUE(&PREFIX *CAT 'DILIB')
             CHGVAR     VAR(&DPLIB ) VALUE(&PREFIX *CAT 'DPLIB')

/* Clear Loan IQ Extract file (this is in the HVB part of the library list */

             CLRPFM     FILE(BVEREXTRPD)

             OVRDBF     FILE(EREXTRPD) TOFILE(BVEREXTRPD)

/* Run Loans extract based over Loan IQ files                        */

             OVRDBF     FILE(CLOANCL)  TOFILE(BVCLOANCL)
             OVRDBF     FILE(CLOAN)    TOFILE(BVITCLOAN)
             OVRDBF     FILE(ERPARTL0) TOFILE(BVITPARTL0)
             OVRDBF     FILE(LOAMS)    TOFILE(BVITLOAMS)
             OVRDBF     FILE(LEACXAL3) TOFILE(BVITLEACL3)
             OVRDBF     FILE(LEHISTV0) TOFILE(BVITHISTV0)

/* Seton U1 to tell XX0623 to not extract matured loans, since HVB   */
/* will output matured loans details to the main loans file          */

             CHGJOB SWS(1XXXXXXX)

             CALL       PGM(XX0623)

             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))

/* Run Facilities extract based over Loan IQ files                   */

             OVRDBF     FILE(FCLTY)    TOFILE(BVITFCLTY)

             CALL       PGM(XX0625)

             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(DBERR))

/* Save xxERDLIB - this will be useful for component ERC0690LIQ      */

             CHKOBJ     OBJ(&DILIB/ERSAVF1) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTSAVF +
                          FILE(&DILIB/ERSAVF1) TEXT('Save file for +
                          xxERDLIB') AUT(*ALL))

 /*          SAVLIB     LIB(&ERDLIB) DEV(*SAVF) SAVF(&DILIB/ERSAVF1)   */
             SAVLIB     LIB(&ERDLIB) DEV(*SAVF) SAVF(&DILIB/ERSAVF1) +
                          CLEAR(*REPLACE)

             GOTO       CMDLBL(EOJ)

 DBERR:
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)

 ERROR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
             SNDMSG     MSG('ERC0600LIQ terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000)

EOJ:
             ENDPGM
