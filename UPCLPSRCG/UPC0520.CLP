/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UP Put compares to screen')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Module                                      */
/*                                                                   */
/*       UPC0520  - Put compares to screen                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSM005  *MOVED     Date 17Aug05              */
/*       Prev Amend No. 228542             Date 11Aug04              */
/*                      CUP024             Date 13Jun03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 04Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     DATE 11Feb98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSM005 - Changes for the Bridge compare for MidasPlus.      */
/*       228542 - RGZPFM has changed at R5V3. Can't use SCC000060 in */
/*                this case. Copying file to QTEMP and back should   */
/*                achieve the same result.                           */
/*       CUP024 - Migration of Bridge ICD to the System Values file. */
/*       CPK015 - 4.01 packaging.  Handling DZLIB.  Recompile.       */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&RTRN &NEWL &NEWF &NEWM &EERELN &NEWME &S)                */ /*CSM005*/
             PGM        PARM(&RTRN &NEWL &NEWF &NEWM &EERELN &NEWME +
                          &S &LIBST &PTFUPG)                                              /*CSM005*/
 
/**COPY*UPCPYSRC,UPSVALDCL*                                          */  /* */ /*CUP024*/ /*CSM005*/
             DCL        VAR(&RTRN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NEWL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PTFUPG) TYPE(*CHAR) LEN(10)                                  /*CSM005*/
             DCL        VAR(&EERELN) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&NEWME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWMO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCD) TYPE(*CHAR) LEN(92)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBST) TYPE(*CHAR) LEN(10)
             DCL        VAR(&S) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OVCSEQ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LENY) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&UPP02X) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UPP02Y) TYPE(*CHAR) LEN(10)
             DCL        VAR(&UPP02) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/************DCLF       FILE(UPUICDPD)                                                 */ /*CUP024*/
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)
 
/************RCVF                                                                      */ /*CUP024*/
/************MONMSG     MSGID(CPF0864)                                                 */ /*CUP024*/
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */  /* */ /*CUP024*/ /*CSM005*/
/**COPY*UPCPYSRC,UPSVALCAL2*                                         */  /* */ /*CUP024*/ /*CSM005*/
 
             CHGVAR     VAR(&UPP02X) VALUE(UPP02P)
             CHKOBJ     OBJ(&PTFUPG/UPP02P) OBJTYPE(*FILE) MBR(&NEWME)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
                CHGVAR     VAR(&UPP02X) VALUE('           ')
             ENDDO
             CHGVAR     VAR(&UPP02Y) VALUE(UPP02PB)
             CHKOBJ     OBJ(&PTFUPG/UPP02PB) OBJTYPE(*FILE) +
                          MBR(&NEWME)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
                CHGVAR     VAR(&UPP02Y) VALUE('           ')
             ENDDO
             IF         COND((&UPP02X *EQ '          ') *AND +
                          (&UPP02Y *EQ '          ')) THEN(GOTO +
                          CMDLBL(ABNOR))
             IF         COND(&UPP02X *NE '          ') THEN(DO)
                CHGVAR     VAR(&UPP02) VALUE(UPP02P)
             ENDDO
             IF         COND(&UPP02Y *NE '          ') THEN(DO)
                CHGVAR     VAR(&UPP02) VALUE(UPP02PB)
             ENDDO
             CALL       PGM(UPC0580) PARM(&UPP02 &PTFUPG &LENY)
 
/**********  IF         COND((&UCLIBL *EQ &NEWL) *OR +                                 */ /*CSM005*/
/**********                  (&UCLIBS *EQ &NEWL)) THEN(DO)                             */ /*CSM005*/
/**********     CHGVAR     VAR(&LIBST) VALUE(&UCLIB)                                   */ /*CSM005*/
/**********  ENDDO                                                                     */ /*CSM005*/
/**********                                                                            */ /*CSM005*/
/**********  IF         COND((&UPLIBL *EQ &NEWL) *OR +                                 */ /*CSM005*/
/**********                  (&UPLIBS *EQ &NEWL)) THEN(DO)                             */ /*CSM005*/
/**********     CHGVAR     VAR(&LIBST) VALUE(&UPLIB)                                   */ /*CSM005*/
/**********  ENDDO                                                                     */ /*CSM005*/
/**********                                                                            */ /*CSM005*/
/**********  IF         COND((&CPLIBL *EQ &NEWL) *OR +                                 */ /*CSM005*/
/**********                  (&CPLIBS *EQ &NEWL)) THEN(DO)                             */ /*CSM005*/
/**********     CHGVAR     VAR(&LIBST) VALUE(&CPLIB)                                   */ /*CSM005*/
/**********  ENDDO                                                                     */ /*CSM005*/
             CHGVAR     VAR(&NEWMO) VALUE('#' *CAT &NEWM)
             CHKOBJ     OBJ(&LIBST/&NEWF) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                IF         COND(&LENY *EQ 112) THEN(DO)
                   CRTSRCPF   FILE(&LIBST/&NEWF) RCDLEN(112)
                ENDDO
                IF         COND(&LENY *EQ 092) THEN(DO)
                   CRTSRCPF   FILE(&LIBST/&NEWF) RCDLEN(92)
                ENDDO
             ENDDO
             CHKOBJ     OBJ(&LIBST/&NEWF) OBJTYPE(*FILE) MBR(&NEWM)
             MONMSG     MSGID(CPF9815) EXEC(GOTO CMDLBL(TAG001))
 
             CPYF       FROMFILE(&LIBST/&NEWF) TOFILE(&LIBST/&NEWF) +
                          FROMMBR(&NEWM) TOMBR(&NEWMO) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*MAP)
             MONMSG     MSGID(CPF2868 CPF2817)
 
/*MEMBER NEWM EXIST*/
             RMVM       FILE(&LIBST/&NEWF) MBR(&NEWM)
 
/*MEMBER NEWM DO NOT EXIST*/
TAG001:
             CPYF       FROMFILE(&NEWL/&NEWF) TOFILE(&LIBST/&NEWF) +
                          FROMMBR(&NEWM) TOMBR(&NEWM) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FROMRCD(1) +
                          TORCD(1) FMTOPT(*MAP)
 
             CLRPFM     FILE(&LIBST/&NEWF) MBR(&NEWM)
 
             CHGDTAARA  DTAARA(*LDA (1 10)) VALUE(&NEWF)
             IF         COND(&LENY *EQ 112) THEN(DO)
                OVRDBF     FILE(UPP02P) MBR(&NEWME)
             ENDDO
             IF         COND(&LENY *EQ 092) THEN(DO)
                OVRDBF     FILE(UPP02PB) MBR(&NEWME)
             ENDDO
             OVRDBF     FILE(QRPG) TOFILE(&LIBST/&NEWF) MBR(&NEWM) +
                          FMTSLR(UPC0530)
             CHGVAR     VAR(&OVCSEQ) VALUE(' ')
             IF         COND(&LENY *EQ 112) THEN(DO)
                CALL      PGM(UP0540) PARM(&RTRN &EERELN &LIBST &NEWF +
                          &NEWM &S &OVCSEQ)
             ENDDO
             IF         COND(&LENY *EQ 092) THEN(DO)
                CALL     PGM(UP0540B) PARM(&RTRN &EERELN &LIBST &NEWF +
                          &NEWM &S &OVCSEQ)
             ENDDO
             IF         COND(&LENY *EQ 112) THEN(DO)
                DLTOVR     FILE(UPP02P)
             ENDDO
             IF         COND(&LENY *EQ 092) THEN(DO)
                DLTOVR     FILE(UPP02PB)
             ENDDO
             DLTOVR     FILE(QRPG)
             IF         COND(&RTRN *EQ 'N') THEN(DO)
                RMVM       FILE(&LIBST/&NEWF) MBR(&NEWM)
                RNMM       FILE(&LIBST/&NEWF) MBR(&NEWMO) NEWMBR(&NEWM)
                MONMSG     MSGID(CPF9815 CPF3178)
             ENDDO
             IF         COND(&RTRN *NE 'N') THEN(DO)
                IF         COND(&OVCSEQ *EQ 'O') THEN(DO)
/**********     RGZPFM  FILE(&LIBST/&NEWF) MBR(&NEWM) SRCOPT(*SEQNBR) +
                          SRCSEQ(1.00 0.10)                                               /*228542*/
                CPYF       FROMFILE(&LIBST/&NEWF) TOFILE(QTEMP/&NEWF) +
                           FROMMBR(&NEWM) TOMBR(&NEWM) MBROPT(*REPLACE) +
                           CRTFILE(*YES) SRCOPT(*SEQNBR) SRCSEQ(1.00 0.10)                /*228542*/
                MONMSG     MSGID(CPF2817)                                                 /*228542*/
                CPYF       FROMFILE(QTEMP/&NEWF) TOFILE(&LIBST/&NEWF) +
                           FROMMBR(&NEWM) TOMBR(&NEWM) +
                           MBROPT(*REPLACE) CRTFILE(*NO)                                  /*228542*/
                MONMSG     MSGID(CPF2817)                                                 /*228542*/
                                                                                          /*228542*/
                ENDDO
             ENDDO
 ABNOR:
             RETURN
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
