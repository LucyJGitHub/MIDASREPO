/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Duplicate posting for linked account')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC3260 - LINKED ACCOUNTS PROCESSING                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR707236           Date 19Aug14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      219121             Date 26May06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 06Nov01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 11May95              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR707236 - REC3260 COB error. Clear workfile TREEODPF if    */
/*                  there are no linked account movements.           */
/*                  (Child: AR707237)                                */
/*       219121 - Message sent to MRUNQ when FUSIONJL is empty.      */
/*       CPK014 - TREEODPF is now a delivered file.                  */
/*       S01408 - Addition of core hook REC3260MP1                   */
/*       S01413  -  Retail 3 Incorporation                           */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(8)
/*/COPY WNCPYSRC,REC3260001                                          */
/**/
             SNDPGMMSG  MSG('REC3260 - Linked accounts proces+
                          sing') TOMSGQ(MRUNQ)
/**/
             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)
/**/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&DMLIB) VALUE(&PRE *CAT 'DMLIB ')
             CHGVAR     VAR(&DPLIB) VALUE(&PRE *CAT 'DPLIB ')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC3260MP1                                          */
                                                                      /*S01408*/
/**/
/*     SECURITY COPY         */
/**/
             CLRPFM     FILE(TREEODPF)                                                  /*AR707236*/
             DLTF       FILE(XREEODPF)
             MONMSG     MSGID(CPF2105)
/**/
STEP1:
             CRTDUPOBJ  OBJ(REEODPF) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(XREEODPF) DATA(*YES)
/**/
             MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 +
                          CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) +
                          EXEC(DO)
             SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REEODPF by +
                          PGM : RE3260 (STEP1)') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/*     DELETE THE COPY FILE       */
/**/
/**********  DLTF       FILE(TREEODPF) */                                                 /*CPK014*/
/**********  MONMSG     MSGID(CPF2105) */                                                 /*CPK014*/
/**/
/*     CREATE THE NEW COPY FILE        */
/**/
STEP2:
/**********  CRTDUPOBJ  OBJ(REEODPF) FROMLIB(&DMLIB) OBJTYPE(*FILE) + */                  /*CPK014*/
/**********               TOLIB(&DPLIB) NEWOBJ(TREEODPF)              */                  /*CPK014*/
/**/                                                                                      /*CPK014*/
/**********  MONMSG     MSGID(CPF0678 CPF2109 CPF2110 CPF2113 CPF2116 + */                /*CPK014*/
/**********               CPF2122 CPF2151 CPF2162 CPF2176 CPF2182) +    */                /*CPK014*/
/**********               EXEC(DO)                                      */                /*CPK014*/
/**********  SNDPGMMSG  MSG('Error in CRTDUPOBJ of file : REEODPF by +  */                /*CPK014*/
/**********               PGM : RE3260 (STEP2)') TOMSGQ(MRUNQ)          */                /*CPK014*/
/**********  GOTO       CMDLBL(EXIT1)                                   */                /*CPK014*/
/**********  ENDDO                                                      */                /*CPK014*/
/**/
/*       COPY THE NEW FILE              */
/**/
/**********  CPYF       FROMFILE(FUSIONJL) TOFILE(&DPLIB/TREEODPF) + */                   /*CPK014*/
/**********               MBROPT(*ADD) FMTOPT(*NOCHK)                */                   /*CPK014*/
             CPYF       FROMFILE(FUSIONJL) TOFILE(&DPLIB/TREEODPF) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)                                 /*CPK014*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*219121*/
/**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error with FUSIONJL found by PGM : +
                          REC3260 (STEP3)') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(EXIT1)
             ENDDO
/**/
/*       COPY IN THE RETAIL END OD DAY POSTINGS      */
/**/
STEP4:
             CPYF       FROMFILE(&DPLIB/TREEODPF) TOFILE(REEODPF) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)
/**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error with REEODPF found by PGM : +
                          REC3260 (STEP4)') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(EXIT1)
             ENDDO
/*/COPY WNCPYSRC,REC3260002                                          */
             GOTO       CMDLBL(ENDPGM)
/**/
 EXIT1:
 /**/
 /*      RESTART THE PGM      */
 /**/
             CPYF       FROMFILE(&DPLIB/XREEODPF) TOFILE(REEODPF) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
 /**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error in RESTART COPY with XREEODPF in +
                          REC3260 (EXIT1)') TOMSGQ(MRUNQ)
             ENDDO
 /**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 ENDPGM:     ENDPGM
