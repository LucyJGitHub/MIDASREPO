/*********************************************************************/
/*OVR    OVRDBF FILE(MBRLISTP) TOFILE(QAFDMBRL)                      */
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UT EXPSRC main program')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas     Utilities Module                                  */
/*                                                                   */
/*       UTC0016 - Expand source: Main Program                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CUT008             Date 21Mar11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK018             Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK008             Date 12Feb97              */
/*                      CAAA01             Date 30Oct95              */
/*                      S01516             DATE 18JUL94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUT008 - CRTOBJ rewrite.                                    */
/*                Amend so that UT0015 can extands sources for RGPLE,*/
/*                CLLE.                                              */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CPK008 - DBA R2 packaging:                                  */
/*                - Changes for source being 112 long.               */
/*       CAAA01 - Allow expanded source to be retained for Midas GUI */
/*                Collector to run and make bold printing optional   */
/*                for EXPSRC (UT0015)                                */
/*       S01516 - Incorporation of enhanced CRTOBJ into core         */
/*                                                                   */
/*********************************************************************/
 
/************PGM        PARM(&FILE &LIB &MBR &SUBM &WRKSTN &OUTPUT)*/ /*CAAA01*/
             PGM        PARM(&FILE &LIB &MBR &SUBM &WRKSTN &OUTPUT +
                          &BOLD)                                      /*CAAA01*/
 
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SUBM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WRKSTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTPUT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&BOLD) TYPE(*CHAR) LEN(1)                 /*CAAA01*/
             DCL        VAR(&SRCSEQ) TYPE(*DEC) LEN(6 2)
             DCL        VAR(&SRCTYP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SEQNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&PATLEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&POSN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&GENRC) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(MBRLISTP)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
             CHGVAR     VAR(&STRLEN) VALUE(10)
             CHGVAR     VAR(&STRPOS) VALUE(1)
             CHGVAR     VAR(&PATLEN) VALUE(1)
 
/*           Scan 'Member' for '*' in case of 'Generic' or 'All'     */
 
             CALL       PGM(QCLSCAN) PARM(&MBR &STRLEN &STRPOS +
                            '*' &PATLEN '0' '0' '' &RESULT)
 
/*    Process for single Source Member                               */
             IF         COND(&RESULT *EQ 0) THEN(DO)
 
/*    Create temporary source file                                   */
/*********** CRTSRCPF   FILE(QTEMP/SOURCEF)                           /*CPK008*/
             CRTSRCPF   FILE(QTEMP/SOURCEF) RCDLEN(112)               /*CPK008*/
             MONMSG     MSGID(CPF0000)
 
/*    Copy source to temporary file                                  */
             CPYSRCF    FROMFILE(&LIB/&FILE) TOFILE(QTEMP/SOURCEF) +
                          FROMMBR(&MBR) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNORM))
 
             RTVMBRD    FILE(QTEMP/SOURCEF) MBR(&MBR) SRCTYPE(&SRCTYP)
/**********  CHGVAR     VAR(&MLSEU) VALUE(&SRCTYP)                                     */ /*CUT008*/
             CHGVAR     VAR(&MLSEU2) VALUE(&SRCTYP)                                       /*CUT008*/
 
/*    Delete any previous user spaces                              */
             DLTUSRSPC  USRSPC(QTEMP/RCDSPC)
             MONMSG     MSGID(CPF0000)
             DLTUSRSPC  USRSPC(QTEMP/FLDSPC)
             MONMSG     MSGID(CPF0000)
 
             OVRPRTF    FILE(UT0015P1) USRDTA(EXPAND) SPLFNAME(&MBR)
             OVRDBF     FILE(SOURCEF) MBR(&MBR) SECURE(*YES)
 
/**********  CALL       PGM(UT0015) PARM(&FILE &LIB &SRCSEQ &MBR +    /*CAAA01*/
/**********               &MLSEU) **/                                 /*CAAA01*/
/**********  CALL       PGM(UT0015) PARM(&FILE &LIB &SRCSEQ &MBR +                     */ /*CUT008*/
/**********               &MLSEU &BOLD)                                     */ /*CAAA01*/ /*CUT008*/
             CALL       PGM(UT0015) PARM(&FILE &LIB &SRCSEQ &MBR +
                          &MLSEU2 &BOLD)                                                  /*CUT008*/
 
/*    Display spool file if requested                              */
             IF         COND(&OUTPUT = '*') THEN(DO)
             DSPSPLF    FILE(&MBR) SPLNBR(*LAST)
             DLTSPLF    FILE(&MBR) SPLNBR(*LAST)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/*           Process for when there is more than one Source Member   */
/*           Get Member List of Source in File/Library               */
 
             DSPFD      FILE(&LIB/&FILE) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/MBRLISTP)
             MONMSG     MSGID(CPF0000)
 
/*    If generic, set flag and positions to check                    */
             IF         COND(&RESULT *GT 1) THEN(DO)
             CHGVAR     VAR(&POSN) VALUE(&RESULT - 1)
             CHGVAR     VAR(&GENRC) VALUE('Y')
             ENDDO
 
/*    Delete any previous user spaces                              */
             DLTUSRSPC  USRSPC(QTEMP/RCDSPC)
             MONMSG     MSGID(CPF0000)
             DLTUSRSPC  USRSPC(QTEMP/FLDSPC)
             MONMSG     MSGID(CPF0000)
 
/*    Create temporary source file                                   */
/*********** CRTSRCPF   FILE(QTEMP/SOURCEF)                           /*CPK008*/
             CRTSRCPF   FILE(QTEMP/SOURCEF) RCDLEN(112)               /*CPK008*/
             MONMSG     MSGID(CPF0000) EXEC(RMVM FILE(QTEMP/SOURCEF) +
                          MBR(*ALL))
 
 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDLOOP))
 
/*          Check that if 'Generic' then Source is a valid selection */
             IF         COND(&GENRC = 'Y') THEN(DO)
             IF         COND(%SST(&MBR 1 &POSN) *NE %SST(&MLNAME 1 +
                          &POSN)) THEN(GOTO CMDLBL(LOOP))
             ENDDO
             DLTOVR     FILE(SOURCEF)
             MONMSG     MSGID(CPF0000)
 
/*    Copy source into temporary file                                */
             CPYSRCF    FROMFILE(&LIB/&FILE) TOFILE(QTEMP/SOURCEF) +
                          FROMMBR(&MLNAME) TOMBR(*FROMMBR) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNORM))
 
             OVRPRTF    FILE(UT0015PR) USRDTA(EXPAND) SPLFNAME(&MLNAME)
             OVRDBF     FILE(SOURCEF) MBR(&MLNAME)
 
/**********  CALL       PGM(UT0015) +                                 /*CAAA01*/
/**********             PARM(&FILE &LIB &SRCSEQ &MLNAME &MLSEU) **/   /*CAAA01*/
/**********  CALL       PGM(UT0015) PARM(&FILE &LIB &SRCSEQ &MLNAME +                  */ /*CUT008*/
/**********               &MLSEU &BOLD)                                     */ /*CAAA01*/ /*CUT008*/
             CALL       PGM(UT0015) PARM(&FILE &LIB &SRCSEQ &MLNAME +
                          &MLSEU2 &BOLD)                                                  /*CUT008*/
 
             GOTO       CMDLBL(LOOP)
 
/*    End of file - no errors found                                  */
 ENDLOOP:
             GOTO       CMDLBL(ENDPGM)
 
/*    If errors have occurred in the RPG program or elsewhere        */
 ABNORM:
             IF         COND(&SUBM *EQ 'N') THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Expand +
                          source process failed. See job log for +
                          details') TOPGMQ(*PRV) MSGTYPE(*COMP)
             ENDDO
 
             IF         COND(&SUBM *EQ 'Y') THEN(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Expand +
                          source process failed. See job log for +
                          details') TOMSGQ(&WRKSTN) MSGTYPE(*COMP)
             ENDDO
 
/*           End of process                                        */
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
