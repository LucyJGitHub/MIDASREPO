/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SM Check contents of "to" DTALIB')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC0012 - Check contents of "to" DTALIB                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. CUP034             Date 24Jan07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP033             Date 06Jul06              */
/*                      CSM005             Date 21Sep05              */
/*                      CSM003             Date 30May05              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP034 - Reduce size of implementation library.             */
/*       CUP033 - Removal of System Value /COPYs.                    */
/*       CSM005 - Changes to /COPYs.  Recompile.                     */
/*       CSM003 - Use system value rather than UPSTAT.               */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                                       */ /*CUP033*/
             PGM        PARM(&PFXSVAL &OPFXSVAL)                                          /*CUP033*/
 
             DCL        VAR(&PFXSVAL) TYPE(*CHAR) LEN(20)                                 /*CUP033*/
             DCL        VAR(&OPFXSVAL) TYPE(*CHAR) LEN(20)                                /*CUP033*/
 
/**COPY*UPCPYSRC,UPSVALDCL*                                          */ /*             */ /*CUP033*/
/**********  DCL        VAR(&TOSBSID) TYPE(*CHAR) LEN(2)                               */ /*CSM003*/
             DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP033*/
             DCL        VAR(&OLDSBSID) TYPE(*CHAR) LEN(2)                                 /*CUP033*/
             DCL        VAR(&BLANKSVAL) TYPE(*CHAR) LEN(1) VALUE('N')                     /*CUP033*/
             DCL        VAR(&FROMDTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TODTALIB) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&UPSTAT) TYPE(*CHAR) LEN(256)                              */ /*CSM003*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
             DCLF       FILE(UPSVALJ0)                                                    /*CUP033*/
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/**COPY*UPCPYSRC,UPSVALCAL1*                                         */ /*             */ /*CUP033*/
/**COPY*UPCPYSRC,UPSVALCAL3*                                         */ /*  */ /*CSM003*/ /*CUP033*/
 
/**********  IF         COND(&PTFUPG *EQ ' ' *OR &SBSID *EQ ' ') +                     */ /*CSM003*/
/**********               THEN(DO)                                                     */ /*CSM003*/
/**********  IF         COND(&PTFUPG**EQ''''**OR&&SBSID *EQ ' ' *OR +                  */ /*CUP033*/
/**********               &OLDSBSID *EQ ' ') THEN(DO)                       */ /*CSM003*/ /*CUP033*/
 
VALIDATE:                                                                                 /*CUP033*/
             RCVF                                                                         /*CUP033*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                                           /*CUP033*/
                GOTO       CMDLBL(CHECK)                                                  /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&GISVAL *EQ &PFXSVAL) THEN(DO)                               /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&SBSID) VALUE(&GIVAL)                                   /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             IF         COND(&GISVAL *EQ &OPFXSVAL) THEN(DO)                              /*CUP033*/
                IF         COND(&GIVAL *EQ ' ') THEN(DO)                                  /*CUP033*/
                   CHGVAR     VAR(&BLANKSVAL) VALUE('Y')                                  /*CUP033*/
                ENDDO                                                                     /*CUP033*/
                ELSE       CMD(DO)                                                        /*CUP033*/
                   CHGVAR     VAR(&OLDSBSID) VALUE(&GIVAL)                                /*CUP033*/
                ENDDO                                                                     /*CUP033*/
             ENDDO                                                                        /*CUP033*/
 
             GOTO       CMDLBL(VALIDATE)                                                  /*CUP033*/
 
 CHECK:                                                                                   /*CUP033*/
             IF         COND(&BLANKSVAL *EQ 'Y') THEN(DO)                                 /*CUP033*/
/* Set up messages for Midas Information Screen  */
                RTVMSG     MSGID(UPM0003) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (101 50)) VALUE(&MESSAGE)
                RTVMSG     MSGID(UPM0004) MSGF(UTMSGF) MSG(&MESSAGE)
                CHGDTAARA  DTAARA(MIDASMSG (151 50)) VALUE(&MESSAGE)
                CALL       PGM(SCC0010) PARM('SMC0012' 'ENTER' ' ')
                GOTO       CMDLBL(END)
             ENDDO
 
/* Set up library list. */                                                                /*CUP034*/
             CALL       PGM(UPC0014) PARM(&SBSID)                                         /*CUP034*/
 
/* Set up library names */
/**********  CHGVAR     VAR(&FROMDTALIB) VALUE(&SBSID *TCAT 'DTALIB')                  */ /*CSM003*/
/**Retrieve*to*library*prefix*from*data*area*UPSTAT**/ /*                              */ /*CSM003*/
/**********  RTVDTAARA  DTAARA(&PTFUPG/UPSTAT) RTNVAR(&UPSTAT)                         */ /*CSM003*/
/**********  CHGVAR     VAR(&TOSBSID) VALUE(%SST(&UPSTAT 62 2))                        */ /*CSM003*/
/**If*this*is*blank*then*this*should*mean*that*this*is*an*'XX'**/ /*                   */ /*CSM003*/
/**to*'XX'*type*migration.**************************************/ /*                   */ /*CSM003*/
/**********  IF         COND(&TOSBSID *EQ '  ') THEN(DO)                               */ /*CSM003*/
/**********     CHGVAR     VAR(&TOSBSID) VALUE(%SST(&UPSTAT 60 2))                     */ /*CSM003*/
/**********  ENDDO                                                                     */ /*CSM003*/
/**********  CHGVAR     VAR(&TODTALIB) VALUE(&TOSBSID *TCAT 'DTALIB')                  */ /*CSM003*/
             CHGVAR     VAR(&FROMDTALIB) VALUE(&OLDSBSID *TCAT 'DTALIB')                  /*CSM003*/
             CHGVAR     VAR(&TODTALIB) VALUE(&SBSID *TCAT 'DTALIB')                       /*CSM003*/
 
/* Delete outfiles if they already exist */
             DLTF       FILE(QTEMP/FROMDTALIB)
             MONMSG     MSGID(CPF0000)
 
/* Produce outfile of files in "from" DTALIB */
             DSPOBJD    OBJ(&FROMDTALIB/*ALL) OBJTYPE(*ALL) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/FROMDTALIB)
 
/* Produce query to identify files not in "to" library that          */
/*  exist in "from" library                                          */
             OPNQRYF    FILE((QTEMP/FROMDTALIB) (UPDTLBOF)) +
                          FORMAT(QADSPOBJ) JFLD((1/ODOBNM 2/UPDTLBOF +
                          *EQ)) JDFTVAL(*ONLYDFT)
             CPYFRMQRYF FROMOPNID(FROMDTALIB) TOFILE(QTEMP/SMDTNFQF) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CLOF       OPNID(FROMDTALIB)
 
/* Call program to produce report of files not in "to" library       */
             CLRPFM     FILE(UPNOTFPD) MBR(UPDTNFQF)
             MONMSG     MSGID(CPF3141)
             CPYF       FROMFILE(QTEMP/SMDTNFQF) TOFILE(UPNOTFPD) +
                          TOMBR(SMDTNFQF) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             OVRDBF     FILE(UPNOTFPD) TOFILE(UPNOTFPD) MBR(SMDTNFQF)
             CALL       PGM(UP0260)
/* Call program to produce display file for file selection */
             CALL       PGM(UP0261) PARM(&TODTALIB)
             DLTOVR     FILE(UPNOTFPD)
 
             GOTO       CMDLBL(END)
ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
