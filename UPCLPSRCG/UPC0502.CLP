/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Bridge on-screen compares')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0502 - CPP for command UPGCOMP                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSM005             Date 17Aug05              */
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CPK015             Date 23May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     Date 11Feb98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSM005 - Tidying up of Bridge compare tool.                 */
/*       CPK015 - 4.01 packaging.  UPSRCC* files are not used.       */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&QUALFILEA &MBRA &QUALFILEB &MBRB &LIST)                  */ /*CSM005*/
             PGM        PARM(&FILEA &LIBA &MBRA &FILEB &LIBB &MBRB +
                          &LIST &PTFUPG &LIBC)                                            /*CSM005*/
 
/**********  DCL        VAR(&QUALFILEA) TYPE(*CHAR) LEN(20)                            */ /*CSM005*/
/**********  DCL        VAR(&QUALFILEB) TYPE(*CHAR) LEN(20)                            */ /*CSM005*/
             DCL        VAR(&MBRA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBRB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)                                  /*CSM005*/
             DCL        VAR(&LIBC) TYPE(*CHAR) LEN(10)                                    /*CSM005*/
 
/**********  DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10)                                */ /*CSM005*/
/**********  DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                                */ /*CSM005*/
/**********  DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                                */ /*CSM005*/
             DCL        VAR(&FILEA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILEB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GENF) TYPE(*LGL) LEN(1)
             DCL        VAR(&GENM) TYPE(*LGL) LEN(1)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&L) TYPE(*DEC) LEN(2 0) VALUE(1)
/************DCL        VAR(&RTNLIB) TYPE(*CHAR) LEN(10)                               */ /*CPK015*/
             DCL        VAR(&MBRGEN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&LEN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(QADSPOBJ)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
 
             CHGJOB     RUNPTY(50) TIMESLICE(10000) PURGE(*NO)
/**********  CHGVAR     VAR(&FILEA) VALUE(%SST(&QUALFILEA 1 10))                       */ /*CSM005*/
/**********  CHGVAR     VAR(&FILEB) VALUE(%SST(&QUALFILEB 1 10))                       */ /*CSM005*/
/**********  CHGVAR     VAR(&LIBA) VALUE(%SST(&QUALFILEA 11 10))                       */ /*CSM005*/
/**********  CHGVAR     VAR(&LIBB) VALUE(%SST(&QUALFILEB 11 10))                       */ /*CSM005*/
             CHGVAR     VAR(&FILE) VALUE(&FILEB)
             CHGVAR     VAR(&MBR) VALUE(&MBRB)
 
/**Retrieve*system*prefix*and*set*up*library*names**/ /*                               */ /*CSM005*/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                           */ /*CSM005*/
/**********  CHGVAR     VAR(&DVLIB) VALUE(&PREFIX *TCAT 'DVLIB')                       */ /*CSM005*/
/**********  CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *TCAT 'DPLIB')                       */ /*CSM005*/
 
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
 
/**********  CALL       PGM(UP0502) PARM(&JOB &USER &NBR &LIBA +                       */ /*CSM005*/
/**********               &FILEA &MBRA &LIBB &FILEB &MBRB)                             */ /*CSM005*/
             CALL       PGM(UP0502) PARM(&JOB &USER &NBR &LIBA +
                          &FILEA &MBRA &LIBB &FILEB &MBRB &LIBC)                          /*CSM005*/
 
             CALL       PGM(UPC0590) PARM(&FILEA &LIBA &FILEB &LIBB +
                          &LEN)
/**********  PREPSRCE   NEWF(&LIBB/&FILEB) NEWM(&MBRB) +                               */ /*CSM005*/
/**********               OLDF(&LIBA/&FILEA) OLDM(&MBRA) NBR(&NBR) +                   */ /*CSM005*/
/**********               LEN(&LEN)                                                    */ /*CSM005*/
/**********  IF         COND(&LIBA *EQ ' ' *OR &LIBB *EQ ' ') THEN(DO)                 */ /*CSM005*/
/**********     SNDPGMMSG  MSG('Library name must be entered')                         */ /*CSM005*/
/**********     RETURN                                                                 */ /*CSM005*/
/**********  ENDDO                                                                     */ /*CSM005*/
             CALL       PGM(UPC000500) PARM(&FILEB &LIBB &MBRB &FILEA +
                          &LIBA &MBRA &NBR &LEN &PTFUPG)                                  /*CSM005*/
 
 A:
             IF         COND(%SST(&FILEA &L 1) *EQ '*') THEN(CHGVAR +
                          VAR(&GENF) VALUE('1'))
             ELSE       CMD(IF COND(&L *LT 10) THEN(DO))
                CHGVAR     VAR(&L) VALUE(&L + 1)
                GOTO       CMDLBL(A)
             ENDDO
             CHGVAR     VAR(&L) VALUE(1)
 B:
             IF         COND(%SST(&MBRA &L 1) *EQ '*') THEN(DO)
                IF         COND(&L *NE 1) THEN(DO)
                   CHGVAR     VAR(&L) VALUE(&L - 1)
                   CHGVAR     VAR(&MBRGEN) VALUE(%SST(&MBRA 1 &L))
                ENDDO
                ELSE       CMD(CHGVAR VAR(&GENM) VALUE('1'))
                ENDDO
             ELSE       CMD(IF COND(&L *LT 10) THEN(DO))
                CHGVAR     VAR(&L) VALUE(&L + 1)
                GOTO       CMDLBL(B)
             ENDDO
 
             IF         COND(&GENF) THEN(DO)
                DLTF       FILE(QTEMP/QADSPOBJ)
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
                DSPOBJD    OBJ(&LIBA/&FILEA) OBJTYPE(*FILE) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/QADSPOBJ)
                OVRDBF     FILE(QADSPOBJ) TOFILE(QTEMP/QADSPOBJ) +
                          LVLCHK(*NO)
 C:             RCVF
                MONMSG     MSGID(CPF0864) EXEC(RETURN)
                CHGVAR     VAR(&FILEA) VALUE(&ODOBNM)
             ENDDO
             IF         COND(&FILE *EQ *SAME) THEN(CHGVAR VAR(&FILEB) +
                          VALUE(&FILEA))
             IF         COND(&GENM *OR &MBRGEN *NE ' ') THEN(DO)
                CHKOBJ     OBJ(&LIBA/&FILEA) OBJTYPE(*FILE)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                 SNDPGMMSG MSGID(CPF9801) MSGF(QCPFMSG) MSGDTA(&FILEA +
                          *CAT &LIBA *CAT 'FILE   ')
                   RETURN
                ENDDO
                CHKOBJ     OBJ(&LIBB/&FILEB) OBJTYPE(*FILE)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                 SNDPGMMSG MSGID(CPF9801) MSGF(QCPFMSG) MSGDTA(&FILEA +
                          *CAT &LIBB *CAT 'FILE   ')
                   IF         COND(&GENF) THEN(GOTO CMDLBL(C))
                   ELSE       CMD(RETURN)
                ENDDO
                DLTF       FILE(QTEMP/MEMBERS)
                MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
                DSPFD      FILE(&LIBA/&FILEA) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) FILEATR(*PF) +
                          OUTFILE(QTEMP/MEMBERS)
                MONMSG     MSGID(CPF0000) EXEC(DO)
                   IF         COND(&GENF) THEN(GOTO CMDLBL(C))
                   RETURN
                ENDDO
                OVRDBF FILE(MEMBERS) TOFILE(QTEMP/MEMBERS) LVLCHK(*NO)
D:              CALL       PGM(UP0418) PARM(&MBRA &FILEA &TEXT)
                IF         COND(&MBRA *EQ ' ') THEN(DO)
                   IF         COND(&GENF) THEN(GOTO CMDLBL(C))
                   ELSE       CMD(RETURN)
                ENDDO
             ENDDO
             IF         COND(&MBRGEN *NE ' ' *AND %SST(&MBRA 1 &L) +
                          *NE %SST(&MBRGEN 1 &L)) THEN(GOTO CMDLBL(D))
             IF         COND((&MBR *EQ *SAME) *OR (&MBR *EQ *ALL)) +
                          THEN(CHGVAR VAR(&MBRB) VALUE(&MBRA))
             CHKOBJ     OBJ(&LIBA/&FILEA) OBJTYPE(*FILE) MBR(&MBRA)
             MONMSG     MSGID(CPF9815) EXEC(DO)
                SNDPGMMSG MSGID(CPF9815) MSGF(QCPFMSG) MSGDTA(&FILEA +
                          *CAT &LIBA *CAT &MBRA)
                IF         COND(&GENF) THEN(GOTO CMDLBL(C))
                ELSE       CMD(RETURN)
             ENDDO
             MONMSG     MSGID(CPF9800) EXEC(DO)
                SNDPGMMSG MSGID(CPF9801) MSGF(QCPFMSG) MSGDTA(&FILEA +
                          *CAT &LIBA *CAT 'FILE   ')
                RETURN
             ENDDO
             CHKOBJ     OBJ(&LIBB/&FILEB) OBJTYPE(*FILE) MBR(&MBRB)
             MONMSG     MSGID(CPF9815) EXEC(DO)
                SNDPGMMSG  MSGID(CPF9815) MSGF(QCPFMSG) MSGDTA(&FILEB +
                          *CAT &LIBB *CAT &MBRB)
                IF         COND(&GENM *OR &MBRGEN *NE ' ') THEN(GOTO +
                          CMDLBL(D))
                IF         COND(&GENF) THEN(GOTO CMDLBL(C))
                ELSE       CMD(RETURN)
                ENDDO
                MONMSG     MSGID(CPF9800) EXEC(DO)
                SNDPGMMSG  MSGID(CPF9801) MSGF(QCPFMSG) MSGDTA(&FILEB +
                          *CAT &LIBB *CAT 'FILE   ')
                IF         COND(&GENF) THEN(GOTO CMDLBL(C))
                ELSE       CMD(RETURN)
             ENDDO
 
/************MOVOBJ     OBJ(&DPLIB/UPSRCCPD) OBJTYPE(*FILE) +                          */ /*CPK015*/
/************             TOLIB(&DVLIB)                                                */ /*CPK015*/
/************CRTDUPOBJ  OBJ(UPSRCC*) FROMLIB(&DVLIB) OBJTYPE(*FILE) +                  */ /*CPK015*/
/************             TOLIB(QTEMP)                                                 */ /*CPK015*/
/************MONMSG     MSGID(CPF0000) EXEC(DO)                                        */ /*CPK015*/
/************   CLRPFM     FILE(QTEMP/UPSRCCPD)                                        */ /*CPK015*/
/************ENDDO                                                                     */ /*CPK015*/
/************MOVOBJ     OBJ(&DVLIB/UPSRCCPD) OBJTYPE(*FILE) +                          */ /*CPK015*/
/************             TOLIB(&DPLIB)                                                */ /*CPK015*/
/************CPYSRCF    FROMFILE(&LIBB/&FILEB) +                                       */ /*CPK015*/
/************             TOFILE(QTEMP/UPSRCCPD) FROMMBR(&MBRB) +                      */ /*CPK015*/
/************             TOMBR(*FIRST) MBROPT(*ADD)                                   */ /*CPK015*/
/************OVRDBF     FILE(QRPGSRC) TOFILE(&LIBA/&FILEA) +                           */ /*CPK015*/
/************             MBR(&MBRA) LVLCHK(*NO)                                       */ /*CPK015*/
/************OVRDBF     FILE(UPSRCCL0) TOFILE(QTEMP/UPSRCCL0) +                        */ /*CPK015*/
/************             LVLCHK(*NO)                                                  */ /*CPK015*/
/************OVRDBF     FILE(UPSRCCPD) TOFILE(QTEMP/UPSRCCPD) +                        */ /*CPK015*/
/************             LVLCHK(*NO)                                                  */ /*CPK015*/
/************IF         COND(&GENM *OR &MBRGEN *NE ' ') THEN(GOTO +                    */ /*CPK015*/
/************             CMDLBL(D))                                                   */ /*CPK015*/
/************IF         COND(&GENF) THEN(GOTO CMDLBL(C))                               */ /*CPK015*/
/************RETURN                                                                    */ /*CPK015*/
 
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:      RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSGID(&MSGID)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             IF         COND(&MSGID *EQ ' ') THEN(CHGVAR VAR(&MSGID) +
                          VALUE('*NULL'))
             CHGVAR     VAR(&MSG) VALUE('Error ' *CAT &MSGID *BCAT ' +
                          caused program UPC0502 to terminate; see +
                          errors previously listed')
             SNDPGMMSG  MSG(&MSG)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
