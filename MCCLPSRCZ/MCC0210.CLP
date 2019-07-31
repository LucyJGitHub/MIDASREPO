/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Management Accounts Review')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     General Ledger Module                             */
/*                                                                   */
/*       MCC0210 - Management Accounts Review Enquiry                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 120835             Date 14Jul97              */
/*                      057942             Date 15Jul94              */
/*                      048237             Date 09DEC92              */
/*                                                                   */
/* This program is called from MC0205 and calls MC0210 and MCC0220   */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       120835 - Database error using invalid period number         */
/*       057942 - If the physical/logical file members for the       */
/*                control group do not exist, add them, else the     */
/*                default of MBR(*FIRST) will be used and the data   */
/*                for this member will be corrupted.                 */
/*       048237 - Speedup Management Accounts                        */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&GCD &PYR &PNO &RTCD)
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256) /* Local Data +
                          Area */
             DCL        VAR(&GCD) TYPE(*CHAR) LEN(2) /* Group code */
             DCL        VAR(&PYR) TYPE(*CHAR) LEN(4) /* Period +
                          year */
             DCL        VAR(&PNO) TYPE(*CHAR) LEN(2) /* Period +
                          number */
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(1) /* Return code */
             DCL        VAR(&INUSE) TYPE(*CHAR) LEN(1) /* In use */
/************DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2) /* System  */  /*048237*/
/************DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10) /* xxDPLIB */ /*048237*/
/************DCL        VAR(&RPY) TYPE(*CHAR) LEN(1) /* Msg reply */  /*048237*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global Monitor Message                                            */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/** If the required members do not exist, create them.            */ /*057942*/
/** This will be required where a database is restored containing */ /*057942*/
/** control groups for which the pf/lf members do not exist.      */ /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLHIBLPD) OBJTYPE(*FILE) MBR(&GCD)       /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(GLHIBLPD) +
                        MBR(&GCD))                                   /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLHIBLL3) OBJTYPE(*FILE) MBR(&GCD)       /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLHIBLL3) +
                        MBR(&GCD) DTAMBRS((GLHIBLPD (&GCD))))        /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLHIBLL1) OBJTYPE(*FILE) MBR(&GCD)       /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLHIBLL1) +
                        MBR(&GCD) DTAMBRS((GLHIBLPD (&GCD))))        /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLAVBLPD) OBJTYPE(*FILE) MBR(&GCD)       /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(GLAVBLPD) +
                        MBR(&GCD))                                   /*057942*/
/* */                                                                /*057942*/
             CHKOBJ     OBJ(GLAVBLL1) OBJTYPE(*FILE) MBR(&GCD)       /*057942*/
             MONMSG     MSGID(CPF9815) EXEC(ADDLFM FILE(GLAVBLL1) +
                        MBR(&GCD) DTAMBRS((GLAVBLPD (&GCD))))        /*057942*/
/* */                                                                /*057942*/
/* Override files to the member for the requested group              */
 
             OVRDBF     FILE(GLHIBLL3) MBR(&GCD)
             OVRDBF     FILE(GLHIBLL1) MBR(&GCD)
             OVRDBF     FILE(GLAVBLL1) MBR(&GCD)
 
/* Call Enquiry program                                              */
 
LOOP:
             CALL       PGM(MC0210) PARM(&GCD &PYR &PNO &RTCD)
/************DLTOVR     FILE(*ALL)                                    /*048237*/
 
/* Check for return code of '1', Period not found                      *120835*/
                                                                      /*120835*/
             IF         COND(&RTCD *EQ '1') THEN(DO)                  /*120835*/
               DLTOVR     FILE(*ALL)                                  /*120835*/
               GOTO       CMDLBL(END)                                 /*120835*/
             ENDDO                                                    /*120835*/
                                                                      /*120835*/
/* Check for return code of 'R', Recreate requested                  */
 
             IF         COND(&RTCD *EQ 'R') THEN(DO)
 
/* Allocate Recreate Program if not inuse and Set INUSE Flag          /*048237*/
                                                                      /*048237*/
             IF         COND(&INUSE *NE 'Y') THEN(DO)                 /*048237*/
                                                                      /*048237*/
             ALCOBJ     OBJ((MC0220 *PGM *EXCLRD)) WAIT(0)            /*048237*/
             MONMSG     MSGID(CPF1002) EXEC(DO)                       /*048237*/
                CHGVAR     VAR(&RTCD) VALUE('B')                      /*048237*/
                GOTO       CMDLBL(LOOP)                               /*048237*/
             ENDDO                                                    /*048237*/
             ENDDO                                                    /*048237*/
                                                                      /*048237*/
             CHGVAR     VAR(&INUSE) VALUE('Y')                        /*048237*/
/************                                                         /*048237*/
/**Check*in*use*flag.*Exit*with*return*code*'B'*if*already*in*use*/   /*048237*/
 
/************RTVDTAARA  DTAARA(MC0220 (1 1)) RTNVAR(&INUSE)           /*048237*/
/************IF COND(&INUSE *EQ 'Y') THEN(DO)                         /*048237*/
/************   CHGVAR     VAR(&RTCD) VALUE('B')                      /*048237*/
/************   GOTO       CMDLBL(LOOP)                               /*048237*/
/************ENDDO                                                    /*048237*/
/************                                                         /*048237*/
/**If*not*already*in*use,*set*flag*to*'Y'***/                         /*048237*/
/************                                                         /*048237*/
/************ELSE       CMD(DO)                                       /*048237*/
/************   CHGDTAARA  DTAARA(MC0220 (1 1)) VALUE('Y')            /*048237*/
/************ENDDO                                                    /*048237*/
 
/* Remove members from security copy PFs and LFs                     */
 
             DLTOVR     FILE(*ALL)                                    /*048237*/
             RMVM       FILE(XGLHIBLL0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLL1) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLL2) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLL3) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLL4) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLPD) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLL0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLL1) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLL2) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLL3) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLPD) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
 
/* Copy files to security copy files                                 */
 
             CPYF       FROMFILE(GLHIBLPD) TOFILE(XGLHIBLPD) +
                          FROMMBR(&GCD) TOMBR(*FROMMBR) MBROPT(*ADD)
             CPYF       FROMFILE(GLAVBLPD) TOFILE(XGLAVBLPD) +
                          FROMMBR(&GCD) TOMBR(*FROMMBR) MBROPT(*ADD)
 
/***Create*GLPOSTL5X*if*is*does*not*exist*to*speedup*OPNQRYF          /*048237*/
 
/*********** RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)           /*048237*/
/*********** CHGVAR     VAR(&DPLIB) VALUE(&SYSID *TCAT 'DPLIB') +
/***********                                                          /*048237*/
/*********** CHKOBJ     OBJ(&DPLIB/GLPOSTL5X) OBJTYPE(*FILE)          /*048237*/
/*********** MONMSG     MSGID(CPF9801) EXEC(CPYF FROMFILE(GLPOSTL5) +
                          TOFILE(&DPLIB/GLPOSTL5X) MBROPT(*ADD) +
                          CRTFILE(*YES))                              /*048237*/
 
/* Rebuild access paths on security copy LFs by adding members       */
 
             ADDLFM     FILE(XGLHIBLL0) MBR(&GCD) DTAMBRS((XGLHIBLPD +
                          (&GCD)))
             ADDLFM     FILE(XGLHIBLL1) MBR(&GCD) DTAMBRS((XGLHIBLPD +
                          (&GCD)))
             ADDLFM     FILE(XGLHIBLL2) MBR(&GCD) DTAMBRS((XGLHIBLPD +
                          (&GCD)))
             ADDLFM     FILE(XGLHIBLL3) MBR(&GCD) DTAMBRS((XGLHIBLPD +
                          (&GCD)))
             ADDLFM     FILE(XGLHIBLL4) MBR(&GCD) DTAMBRS((XGLHIBLPD +
                          (&GCD)))
             ADDLFM     FILE(XGLAVBLL0) MBR(&GCD) DTAMBRS((XGLAVBLPD +
                          (&GCD)))
             ADDLFM     FILE(XGLAVBLL1) MBR(&GCD) DTAMBRS((XGLAVBLPD +
                          (&GCD)))
             ADDLFM     FILE(XGLAVBLL2) MBR(&GCD) DTAMBRS((XGLAVBLPD +
                          (&GCD)))
             ADDLFM     FILE(XGLAVBLL3) MBR(&GCD) DTAMBRS((XGLAVBLPD +
                          (&GCD)))
 
/* Override to security copies                                       */
 
             OVRDBF     FILE(GLHIBLPD) TOFILE(XGLHIBLPD) MBR(&GCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLHIBLL0) TOFILE(XGLHIBLL0) MBR(&GCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLHIBLL1) TOFILE(XGLHIBLL1) MBR(&GCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLHIBLL2) TOFILE(XGLHIBLL2) MBR(&GCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLHIBLL3) TOFILE(XGLHIBLL3) MBR(&GCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLHIBLL4) TOFILE(XGLHIBLL4) MBR(&GCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLAVBLPD) TOFILE(XGLAVBLPD) MBR(&GCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLAVBLL0) TOFILE(XGLAVBLL0) MBR(&GCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLAVBLL1) TOFILE(XGLAVBLL1) MBR(&GCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLAVBLL2) TOFILE(XGLAVBLL2) MBR(&GCD) +
                          LVLCHK(*NO)
             OVRDBF     FILE(GLAVBLL3) TOFILE(XGLAVBLL3) MBR(&GCD) +
                          LVLCHK(*NO)
 
/* Call MCC0220, passing parameters                                  */
 
             CALL       PGM(MCC0220) PARM(&GCD &PYR &PNO &RTCD)
 
/* Check for return code of 'C' or 'Y', Recreate cancelled or failed */
 
             IF         COND(&RTCD *NE 'C' *AND &RTCD *NE 'Y') +
                          THEN(GOTO CMDLBL(LOOP))
             ENDDO
 
/* Reclaim Resources                                                 */
             RCLRSC
 
/* Check for return code of 'C' or 'Y', Recreate cancelled or failed */
 
             IF         COND(&RTCD *EQ 'C' *OR &RTCD *EQ 'Y') THEN(DO)
                    DLTOVR     FILE(*ALL)                             /*048237*/
                    CLRPFM     FILE(XGLHIBLPD) MBR(&GCD)
                    MONMSG     MSGID(CPF3141)
                    CLRPFM     FILE(XGLAVBLPD) MBR(&GCD)
                    MONMSG     MSGID(CPF3141)
                    CHGVAR     VAR(&RTCD) VALUE('Y')
             ENDDO
 
/* If recreate took place and completed normally, update files       */
 
             ELSE       CMD(DO)
/************   RTVDTAARA  DTAARA(MC0220 (1 1)) RTNVAR(&INUSE)        /*048237*/
                IF COND(&INUSE *EQ 'Y' *AND &RTCD *EQ ' ' *OR &INUSE +
                  *EQ 'Y' *AND &RTCD *EQ 'F') THEN(DO)
 
/*ALLOC:*****CHGVAR     VAR(&RPY) VALUE(' ')                          /*048237*/
/************ALCOBJ     OBJ((GLHIBLPD *FILE *EXCL &GCD)) WAIT(1)      /*048237*/
/************MONMSG     MSGID(CPF1002) EXEC(SNDUSRMSG MSG('Mgmt A/cs +/*048237*/
/************             cannot be updated Now. Press Enter to +     /*048237*/
/************             Retry or ''C'' to Cancel') VALUES(C 'R') +  /*048237*/
/************             DFT('R') TOMSGQ(*) MSGRPY(&RPY))            /*048237*/
/************IF         COND(&RPY *EQ 'C') THEN(GOTO CMDLBL(EXIT))    /*048237*/
/************IF         COND(&RPY *EQ 'R') THEN(GOTO CMDLBL(ALLOC))   /*048237*/
/*                                                                    /*048237*/
                   ALCOBJ     OBJ((GLHIBLPD *FILE *EXCL &GCD)) +
                                   WAIT(0)                            /*048237*/
                   MONMSG     MSGID(CPF1002) EXEC(DO)                 /*048237*/
                        CHGVAR     VAR(&RTCD) VALUE('A')              /*048237*/
                        GOTO       CMDLBL(LOOP)                       /*048237*/
                   ENDDO                                              /*048237*/
                                                                      /*048237*/
                   DLTOVR     FILE(*ALL)                              /*048237*/
 
                   CPYF       FROMFILE(XGLHIBLPD) TOFILE(GLHIBLPD) +
                                FROMMBR(&GCD) TOMBR(&GCD) +
                                MBROPT(*REPLACE)
                   MONMSG     MSGID(CPF2869 CPF2817)  +
                                EXEC(CLRPFM FILE(GLHIBLPD) MBR(&GCD))
                   CLRPFM     FILE(XGLHIBLPD) MBR(&GCD)               /*048237*/
                   MONMSG     MSGID(CPF3141)                          /*048237*/
 
                   CPYF       FROMFILE(XGLAVBLPD) TOFILE(GLAVBLPD) +
                                FROMMBR(&GCD) TOMBR(&GCD) +
                                MBROPT(*REPLACE)
                   MONMSG     MSGID(CPF2869 CPF2817)  +
                                EXEC(CLRPFM FILE(GLAVBLPD) MBR(&GCD))
                   CLRPFM     FILE(XGLAVBLPD) MBR(&GCD)               /*048237*/
                   MONMSG     MSGID(CPF3141)                          /*048237*/
                ENDDO
             ENDDO
 
/* Set off In Use Flag                                               */
 
 EXIT:       IF         COND(&RTCD *NE 'E' *AND &RTCD *NE 'P') +
                          THEN(CHGVAR VAR(&INUSE) VALUE(' '))         /*048237*/
/************             THEN(CHGDTAARA DTAARA(MC0220 (1 1)) +       /*048237*/
/************             VALUE('N'))                                 /*048237*/
             DLCOBJ     OBJ((MC0220 *PGM *EXCLRD))                    /*048237*/
             DLCOBJ     OBJ((GLHIBLPD *FILE *EXCL &GCD))
 
/* Check for any switches set                                       */
 
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND(%SWITCH(XXXXXX11) *OR +
                          %SWITCH(XXXXX1XX)) THEN(DO)
                    CHGVAR     VAR(&RTCD) VALUE('Y')
                    RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                    CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                    SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                    MSGDTA(&MEM) TOMSGQ(MOPERQ) TOPGMQ(*EXT)
             ENDDO
             GOTO       CMDLBL(END)
 
/* Database Error Messages will be sent by RCF                       */
 
ABNOR:       CHGVAR     VAR(&RTCD) VALUE('Y')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Management Accounts Review Request ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((MC0220 *PGM *EXCLRD))                    /*048237*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*048237*/
 
 END:        ENDPGM
