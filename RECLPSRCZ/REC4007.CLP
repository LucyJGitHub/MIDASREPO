/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE T&N Accounts - COB Component')               */
/****************************************************************    */
/*                                                                   */
/*       Midas     - Retail T&N Accounts                             */
/*                                                                   */
/*       CLP/REC4007 - COB Component                                 */
/*                                                                   */
/*       (c) Finastra International Limited 2009                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. 118466             Date 18Dec09              */
/*                      BUG27460           Date 18Dec09              */
/*                      CRE015 *CREATE     Date 18Dec09              */
/*------------------------------------------------------------------ */
/*       MD046248 - Finastra Rebranding                              */
/*       118466 - Various changes to solve problems with accrued int.*/
/*       BUG27460 - Applied client fix AH0011 AH0004 AH0003 AH0002   */
/*       AH0011 - OVRDBF RERTMVPD *NO                                */
/*       AH0004 - STRJRNPF RENFMVPD                                  */
/*       AH0003 - STRCMTCTL                                          */
/*       AH0002 - OPNQRYF requires format name of ACPO1              */
/*       CRE015 - Retail Term and Notice Accounts                    */
/*********************************************************************/
 
             PGM PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ACPO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JRNDONE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CCDONE) TYPE(*CHAR) LEN(1)                                   /*118466*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2009')
 
/* Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             SNDPGMMSG  MSG('REC4007 - Term & Notice Close of +
                          Business') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(XXXXXX00)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
             CHGVAR     VAR(&BUSY) VALUE('N')
 
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
 
/* Identify journal library */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&JLIB)
             CHGVAR     VAR(&JLIB) VALUE(&JLIB *TCAT 'JLIB')
 
 /* Create journal environment (for COB) */
 
             CHGJOB     INQMSGRPY(*DFT)
             ENDJRNPF   FILE(*ALL) JRN(&JLIB/REC4007)
             MONMSG     MSGID(CPF0000)
             DLTJRN     JRN(&JLIB/REC4007)
             MONMSG     MSGID(CPF0000)
             DLTJRNRCV  JRNRCV(&JLIB/REC4007)
             MONMSG     MSGID(CPF0000)
             CHGJOB     INQMSGRPY(*RQD)
 
             CRTJRNRCV  JRNRCV(&JLIB/REC4007) AUT(*ALL)
             CRTJRN     JRN(&JLIB/REC4007) JRNRCV(&JLIB/REC4007) +
                          AUT(*ALL)
             CHGVAR     VAR(&JRNDONE) VALUE('Y')
             STRJRNPF   FILE(RERTMVPD RERTMUPD RENFMVPD) +
                          JRN(&JLIB/REC4007) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                                                /*AH0004*/
             MONMSG     MSGID(CPF0000) EXEC(CHGVAR VAR(&JRNDONE) +
                          VALUE(N))
 
 /* Create (temporary) penalty postings file */
 
             DLTF       FILE(QTEMP/GLPENPPD)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(GLSUNDPD) TOFILE(QTEMP/GLPENPPD) +
                          CRTFILE(*YES) NBRRCDS(1)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(GLPENPPD)
 
 /* Collect customer initiated postings across T&N accounts */
 
             CLRPFM     FILE(GLPPOSPD)
             IF         COND(&CSEQ = 1) THEN(CHGVAR VAR(&ACPO) +
                          VALUE('ACPO1'))
             IF         COND(&CSEQ = 2) THEN(CHGVAR VAR(&ACPO) +
                          VALUE('ACPO5'))
             OPNQRYF    FILE((&ACPO *FIRST APOSTPDF) (SDACD1PD) +
                          (TABLETZ)) FORMAT(GLPPOSPD) +
                          QRYSLT('1/atyp *eq ''R'' *and +
                          SDACD1PD/a5atty *eq ''P'' *and +
                          tabletz/cuor *eq %values(''Y'')') +
                          KEYFLD((1/ACNO *ASCEND)) +
                          JFLD((*MAPFLD/ACODA SDACD1PD/A5ACCD *EQ) +
                          (1/TRAT TABLETZ/TRAT *EQ)) MAPFLD((ACODA +
                          '1/acod' *CHAR 10) (RECI '1/reci') (TRAT +
                          '1/trat')) IGNDECERR(*YES) +
                          OPNID(POSTINGS)                                                 /*AH0002*/
             CPYFRMQRYF FROMOPNID(POSTINGS) TOFILE(GLPPOSPD) +
                          MBROPT(*ADD)
             CLOF       OPNID(POSTINGS)
 
             CHGVAR     VAR(&CCDONE) VALUE('Y')                                           /*118466*/
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                                       /*AH0003*/
             MONMSG CPF0000 EXEC(CHGVAR &CCDONE 'N')                                      /*118466*/
 
 /* Call HLL routine */
 
             OVRDBF     FILE(GLSUNDPD) TOFILE(QTEMP/GLPENPPD)
             OVRDBF     FILE(RERTMVPD) SHARE(*NO)                                         /*AH0011*/
 
             CALL       PGM(RE4007)
 
             MONMSG CPF0000 EXEC(CHGJOB SWS(XXXXXX11))
 
/* If completed successfully... */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
             COMMIT
             DLTOVR     FILE(GLSUNDPD)
 
 /* Copy penalty postings to Sundry postings feature */
 
             CPYF       FROMFILE(QTEMP/GLPENPPD) TOFILE(GLSUNDPD) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
             IF         COND(&CSEQ = 1) THEN(DO)
             CALL       PGM(CBC0041) PARM(CRE015 POST)
             ENDDO
             IF         COND(&CSEQ = 2) THEN(DO)
             CALL       PGM(CBC0041) PARM(CRE015 ANWD)
             ENDDO
 
 /* Reset restart flag and clear SAVF if run succesful */
 
                 ALCOBJ     OBJ((RESTAT *DTAARA *EXCLRD))
                 RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)
                 IF         COND(%SWITCH(XX1XXXXX)) THEN(CHGVAR +
                            VAR(%SST(&RESTAT 23 1)) VALUE('Y'))
                 CHGVAR     VAR(&BUSY) VALUE('O')
                 CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
                 CHGDTAARA  DTAARA(RESTAT) VALUE(&RESTAT)
                 DLCOBJ     OBJ((RESTAT *DTAARA *EXCLRD))
             GOTO END
 
             ENDDO
 
/* If did not complete sucessfully...*/
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(ABNOR))
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
              DLTOVR     FILE(GLSUNDPD)
              MONMSG CPF0000
 
  /* Database Error has occurred */
 
              ROLLBACK
              MONMSG CPF0000
              RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
              CHGVAR     VAR(&BUSY) VALUE('N')
              CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
              DMPCLPGM
              SNDPGMMSG  MSG('REC4007 ended abnormally') +
                            TOMSGQ(MOPERQ)
 
END:
 /* Remove journal environment */
 
             IF         COND(&JRNDONE *EQ 'Y') THEN(DO)
             CHGJOB     INQMSGRPY(*DFT)
             ENDJRNPF   FILE(*ALL) JRN(&JLIB/REC4007)
             IF         COND(&CCDONE *EQ 'Y') THEN(ENDCMTCTL)                             /*118466*/
             DLTJRN     JRN(&JLIB/REC4007)
             MONMSG     MSGID(CPF0000)
             DLTJRNRCV  JRNRCV(&JLIB/REC4007)
             MONMSG     MSGID(CPF0000)
             CHGJOB     INQMSGRPY(*RQD)
             ENDDO
 
             ENDPGM
