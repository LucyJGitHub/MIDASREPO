/********************************************************************/
/*O*R****OVRDBF*FILE(CADWNDPD)*TOFILE(ERDWNDPD)                           */      /*ULX004 CER0001*/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas European Reporting - Download to xxERDLIB')     */
/********************************************************************/
/*                                                                  */
/*     MIDAS/ABS - EUROPEAN REPORTING                               */
/*                                                                  */
/******ERC0690  - EUROPEAN REPORTING - Download to xxERDLIB*********   ULX004*/
/*     ERC0690  - EUROPEAN REPORTING - Download to xxCADLIB            ULX004*/
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. ULX004             Date 30Apr97              */
/*                      82577  SL          Date 03Feb95              */
/*                     ERL406 PT         DATE   14JUL94             */
/*                     ER0125 ADs        DATE   17DEC92             */
/*********************************************************************/
/*                                                                  */
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*     ULX004 - Capital Adequacy                                    */
/*     82577  - RETRY CPYF WHEN FILE CANNOT BE ALLOCATED            */
/*     ERL406 - Create file when copying                            */
/*     ER0125 - Dataarea ERSTAT must not be copied to xxERDLIB.     */
/*                                                                  */
/*********************************************************************/
/**/
             PGM
             DCL        VAR(&@XXLIB) TYPE(*CHAR) LEN(2)
/************DCL        VAR(&@ERDLIB) TYPE(*CHAR) LEN(10)             ULX004*/
/**********  DCL        VAR(&@CADLIB) TYPE(*CHAR) LEN(10)                 */       /*ULX004 CER001*/
             DCL        VAR(&@DMLIB) TYPE(*CHAR) LEN(10)
/************DCLF       FILE(ERDWNDPD)                                ULX004*/
             DCLF       FILE(CADWNDPD)                              /*ULX004*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
/* Reset External Switches */
             CHGJOB     SWS(00000000)
 
/* Lock program to show Active  */           /*  E14364  */
             ALCOBJ     OBJ((ER0690PD *FILE *EXCL)) WAIT(30)          /*E19747*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
/* Get the library prefix */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&@XXLIB)
 /***********CHGVAR     VAR(&@ERDLIB) VALUE(&@XXLIB *CAT 'ERDLIB')    ULX004*/
/**********  CHGVAR     VAR(&@CADLIB) VALUE(&@XXLIB *CAT 'CADLIB')        */       /*ULX004 CER001*/
             CHGVAR     VAR(&@DMLIB) VALUE(&@XXLIB *CAT 'DMLIB')
 
 /* Copy each of the physical files */
/*PHYSICALS:           RCVF       RCDFMT(ERDWNDD0)                    ULX004*/
PHYSICALS:             RCVF                                         /*ULX004*/
                       MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDLOOP))
                       OVRDBF   FILE(&VTFNAM) NBRRCDS(&VTRBLK) +
                                SEQONLY(*YES)
 /*********************CPYF       FROMFILE(&VTFNAM) TOFILE(&@ERDLIB/&VTFNAM) +
                                MBROPT(*REPLACE) FMTOPT(*NONE)        ERL406 */
                                                                      /*82577*/
 RETRY:
                                                                      /*82577*/
 /**ERL406********CPYF****FROMFILE(&VTFNAM) TOFILE(&@ERDLIB/&VTFNAM)  *ULX004*/
 /***********             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)*ULX004*/
/**********            CPYF       FROMFILE(&VTFNAM) TOFILE(&@CADLIB/&VTFNAM) +
                                  MBROPT(*REPLACE) CRTFILE(*YES) +
                                  FMTOPT(*MAP *DROP)                      */       /*ULX004 CER001*/
                       CPYF       FROMFILE(&VTFNAM) TOFILE(&VTDNAM) +
                                  MBROPT(*REPLACE) CRTFILE(*YES) +
                                  FMTOPT(*MAP *DROP)                                      /*CER001*/
/**********************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                                FILE(&@ERDLIB/&VTFNAM))                 ULX004*/
/**********            MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                                FILE(&@CADLIB/&VTFNAM))                   /*       /*ULX004 CER001*/
                       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                                FILE(&VTDNAM))                                            /*CER001*/
                                                                      /*82577*/
                       MONMSG     MSGID(CPF2952) EXEC(DO)             /*82577*/
                       DLYJOB     DLY(100)                            /*82577*/
                       GOTO       CMDLBL(RETRY)                       /*82577*/
                       ENDDO                                          /*82577*/
                                                                      /*82577*/
                       DLTOVR     FILE(&VTFNAM)
                       GOTO       CMDLBL(PHYSICALS)
 
ENDLOOP:     DLCOBJ     OBJ((ER0690PD *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
 
 /* Copy data area ERCTLD  */
 /* ER0125   DLTDTAARA  DTAARA(&@ERDLIB/ERCTLD)                    */
 /* ER0125   MONMSG     MSGID(CPF2105)                             */
 /* ER0125   CRTDUPOBJ  OBJ(ERCTLD) FROMLIB(&@DMLIB) +             */
 /* ER0125                OBJTYPE(*DTAARA) TOLIB(&@ERDLIB)         */
 
             RETURN
 
 ERROR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(*LDA (171 10)) VALUE('ERC0690   ')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(*LDA (181 3)) VALUE('001')
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
             SNDPGMMSG  MSGID(DBM0004) MSGF(DRSMM) +
                            MSGDTA(%SST(*LDA 171 13)) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((ER0690PD *FILE *EXCL))
             MONMSG     MSGID(CPF0000)
 
             ENDPGM
