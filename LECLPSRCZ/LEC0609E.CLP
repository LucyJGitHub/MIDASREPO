/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Events File Creation')                       */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Customer Lending Module                        */
/*                                                                   */
/*     LEC0609E  -  EVENTS FILE CREATION RZ TO END OF BOOK           */
/*                                                                   */
/*       (c) Finastra International Limited 2008                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD021605           Date 22Aug13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CCB016  *CREATE    Date 28May08              */
/*      Midas Plus 1.4 Base -----------------------------------------*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   MD021605 - Add a parameter for LE0480.                          */
/*   CCB016 - CoB Performance Enhancements                           */
/*            Generate lending events to end of book for GTS         */
/*            outside critical path of CoB dependencies.             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2008')
 
/*  Global Monitor Message                                                    */
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO ABNOR)
 
/* Retrieve system prefix and set program variables                           */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR     VAR(&DPLIB) VALUE(&PRE *TCAT 'DPLIB')
 
/*  Clear output files                                                        */
 
             DLTF       FILE(QTEMP/LVNTXHH)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(LVNTXHH) FROMLIB(&DPLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) DATA(*NO)
             DLTF       FILE(QTEMP/LVNTXZZ)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(LVNTXZZ) FROMLIB(&DPLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) DATA(*NO)
             CLRPFM     FILE(LELVNTXEL)
 
/*  Override to RZ files                                                      */
 
             OVRDBF     FILE(LVNTXHH) TOFILE(QTEMP/LVNTXHH)
             OVRDBF     FILE(LVNTXZZ) TOFILE(QTEMP/LVNTXZZ)
             OVRDBF     FILE(LVNTXEL) TOFILE(LELVNTXEL) SEQONLY(*YES 100)
 
/*  Set job switch for LE0480 to set End of Book indicator                    */
 
             CHGJOB     SWS(01000000)
 
/**********  CALL       PGM(LE0480)                                */                   /*MD021605*/
             CALL       PGM(LE0480) PARM(' ')                                           /*MD021605*/
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))
 
ABNOR:       IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
             SNDPGMMSG  MSG('LEC0609E Customer Lending Events File +
                          Creation  ended  abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited')
             ENDPGM
