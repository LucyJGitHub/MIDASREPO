/*********************************************************************/
/*XBI    OVRDBF FILE(UPDLVCQT) TOFILE(UPDLVCPD)                      */                   /*CUP021*/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas UP Review/Conflict/Process *ALL Action Files')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Bridge                                              */
/*                                                                   */
/*       UPC8003 - Review/Conflict/Process *ALL Action Files         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. CUP021             Date 24Jan11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK020             Date 02Aug04              */
/*                      CUP022             Date 08Apr04              */
/*                      CUP020  *CREATE    Date 03Jan02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CUP021 - Rewrite of Action File processing.                 */
/*       CPK020 - Take out unnecessary error handling.               */
/*       CUP022 - Pass in &DPLIB instead of &SBSID.                  */
/*                Perform validity check before action file cmd is   */
/*                called.                                            */
/*                When error, output to error message file and       */
/*                generate error report at the end of this program.  */
/*                Remove DSPFFD because it will be done in UPC000799.*/
/*       CUP020 - Additional changes for Action Files                */
/*                                                                   */
/*********************************************************************/
/*****       PGM        PARM(&MODE &PTFDTA &SBSID)                                        /*CUP022*/
/**********  PGM        PARM(&MODE &PTFDTA &DPLIB)                          */ /*CUP022*/ /*CUP021*/
             PGM        PARM(&MODE)                                                       /*CUP021*/
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(9)
/**********  DCL        VAR(&PTFDTA) TYPE(*CHAR) LEN(10)                               */ /*CUP021*/
/*****       DCL        VAR(&SBSID) TYPE(*CHAR) LEN(2)                                    /*CUP022*/
 
/**********  DCL        VAR(&SECCOPY) TYPE(*CHAR) LEN(10)                              */ /*CUP021*/
/**********  DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)                                */ /*CUP021*/
/******      DCL        VAR(&CMD) TYPE(*CHAR) LEN(100)                   */               /*CUP022*/
/* Parameters to call UPC000799 */                                                        /*CUP022*/
/**********  DCL        VAR(&BUILD)    TYPE(*CHAR) LEN(4) VALUE('*NO')      */ /*CUP022*/ /*CUP021*/
/**********  DCL        VAR(&REVIEW)   TYPE(*CHAR) LEN(4) VALUE('*NO')      */ /*CUP022*/ /*CUP021*/
/**********  DCL        VAR(&CONFLICT) TYPE(*CHAR) LEN(4) VALUE('*NO')      */ /*CUP022*/ /*CUP021*/
/**********  DCL        VAR(&PROCESS)  TYPE(*CHAR) LEN(4) VALUE('*NO')      */ /*CUP022*/ /*CUP021*/
/**********  DCL        VAR(&RESET)    TYPE(*CHAR) LEN(4) VALUE('*NO')      */ /*CUP022*/ /*CUP021*/
/**********  DCL        VAR(&OLDLIB)   TYPE(*CHAR) LEN(10) VALUE(' ')       */ /*CUP022*/ /*CUP021*/
/**********  DCL        VAR(&NEWLIB)   TYPE(*CHAR) LEN(10) VALUE(' ')       */ /*CUP022*/ /*CUP021*/
/**********  DCL        VAR(&REVTYP)   TYPE(*CHAR) LEN(7) VALUE('*ALL')     */ /*CUP022*/ /*CUP021*/
/* Parameters for calling UPC008009 */                                                    /*CUP022*/
/**********  DCL        VAR(&MODEV))   TYPE(*CHAR) LEN(10)                  */ /*CUP022*/ /*CUP021*/
             DCL        VAR(&ERROR)    TYPE(*CHAR) LEN(1)                                 /*CUP022*/
/* Parameters passed to UP008010 */                                                       /*CUP022*/
             DCL        VAR(&GENPGM)   TYPE(*CHAR) LEN(10)  VALUE(UPC8003)                /*CUP022*/
             DCL        VAR(&ERRORMSG) TYPE(*CHAR) LEN(100)                               /*CUP022*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
/************DCLF       FILE(UPACTFPD)                                                    /*CUP022*/
/**********  DCLF       FILE(UPGPACTFPD)                                    */ /*CUP022*/ /*CUP021*/
             DCLF       FILE(UPDLVCQT)                                                    /*CUP021*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*           CHGVAR     VAR(&DPLIB) VALUE(&SBSID *TCAT 'DPLIB')                           /*CUP022*/
/**********  CHGVAR     VAR(&MODEV)  VALUE(&MODE)                           */ /*CUP022*/ /*CUP021*/
 
/**Create*temporary*file*to*hold*error*messages.**/ /*                      */ /*CUP022*/ /*CUP021*/
/**********  DLTF       FILE(QTEMP/UPERRMQT)                                */ /*CUP022*/ /*CUP021*/
/**********  MONMSG     MSGID(CPF2105)                                      */ /*CUP022*/ /*CUP021*/
/**********  CRTPF      FILE(QTEMP/UPERRMQT) RCDLEN(100) +                             */ /*CUP021*/
/**********               TEXT('Temporary file for holding error +                     */ /*CUP021*/
/**********               messages')                                        */ /*CUP022*/ /*CUP021*/
 
READNEXT:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
                GOTO       CMDLBL(END)
             ENDDO
 
/* Ignore record if there is no template. */
/**********  IF         COND(&AAUPPF *EQ '*NONE') THEN(DO)                             */ /*CUP021*/
/**********     GOTO       CMDLBL(READNEXT)                                            */ /*CUP021*/
/**********  ENDDO                                                                     */ /*CUP021*/
 
/**Check*if*Action*File*exists*in*the*Bridge*DTA*library.**/ /*                        */ /*CUP021*/
/**********  CHKOBJ     OBJ(&PTFDTA/&AAFRMF) OBJTYPE(*FILE)                            */ /*CUP021*/
/**********  MONMSG     MSGID(CPF9801) EXEC(DO)                                        */ /*CUP021*/
/*****if*file*not*found,*send*out*error*line**/ /*                          */ /*CUP022*/ /*CPK020*/
/**********     CHGVAR     VAR(&ERRORMSG) VALUE('File' *BCAT &AAFRMF +                 */ /*CPK020*/
/**********                *TCAT ' not found in' *BCAT &PTFDTA)             */ /*CUP022*/ /*CPK020*/
/**********     CALL       PGM(UP008010) PARM(*WRITE &GENPGM &ERRORMSG)     */ /*CUP022*/ /*CPK020*/
/**********     IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                 */ /*CUP022*/ /*CPK020*/
/**********        GOTO       CMDLBL(ABNOR)                                 */ /*CUP022*/ /*CPK020*/
/**********     ENDDO                                                       */ /*CUP022*/ /*CPK020*/
 
/*****go*back*to*read*next*record*from*UPACTFQF.**/ /*                      */ /*CUP022*/ /*CUP021*/
/**********     GOTO       CMDLBL(READNEXT)                                            */ /*CUP021*/
/**********  ENDDO                                                                     */ /*CUP021*/
 
/**Perform*validity*check*of*the*file*&AABONF.**/ /*                        */ /*CUP022*/ /*CUP021*/
/**********  CALL       PGM(UPC008009) PARM(&AABONF &MODEV +                           */ /*CUP021*/
/**********                &OLDLIB &NEWLIB &AAFRMF &AAAFLF +                           */ /*CUP021*/
/**********                &AAPROG &AAUPLF &ERROR)                          */ /*CUP022*/ /*CUP021*/
 
/**If*an*error*then*end*program.**/ /*                                      */ /*CUP022*/ /*CUP021*/
/**********  IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ABNOR)            */ /*CUP022*/ /*CUP021*/
 
/**If*&ERROR*=*'Y',**/ /*                                                   */ /*CUP022*/ /*CUP021*/
/**********  IF         COND(&ERROR *EQ 'Y') THEN(DO)                       */ /*CUP022*/ /*CUP021*/
/*****send*out*error*line**/ /*                                             */ /*CUP022*/ /*CUP021*/
/**********     CHGVAR     VAR(&ERRORMSG) VALUE('Error in validity check for' +        */ /*CUP021*/
/**********        *BCAT &AABONF )                                          */ /*CUP022*/ /*CUP021*/
/**********     CALL       PGM(UP008010) PARM(*WRITE &GENPGM &ERRORMSG)     */ /*CUP022*/ /*CUP021*/
/**********     IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                 */ /*CUP022*/ /*CUP021*/
/**********        GOTO       CMDLBL(ABNOR)                                 */ /*CUP022*/ /*CUP021*/
/**********     ENDDO                                                       */ /*CUP022*/ /*CUP021*/
/**********     GOTO       CMDLBL(READNEXT)                                 */ /*CUP022*/ /*CUP021*/
/**********  ENDDO                                                          */ /*CUP022*/ /*CUP021*/
 
/* REVIEW */                                                                              /*CUP022*/
             IF         COND(&MODE *EQ '*REVIEW') THEN(DO)
/*****          DSPFFD     FILE(&AABONF) OUTPUT(*OUTFILE) +
                             OUTFILE(QTEMP/UPDFFDPD)                                      /*CUP022*/
/*****          CHGVAR     VAR(&CMD) VALUE(&AABONF *BCAT 'REVIEW(*YES)')                  /*CUP022*/
/**********     CHGVAR     VAR(&REVIEW) VALUE('*YES')                       */ /*CUP022*/ /*CUP021*/
                ACTIONFILE MODE(*RVW) FILE(&AUMBNM)                                       /*CUP021*/
             ENDDO
 
/* CONFLICT */                                                                            /*CUP022*/
             IF         COND(&MODE *EQ '*CONFLICT') THEN(DO)
/*****          CHGVAR     VAR(&CMD) VALUE(&AABONF *BCAT 'CONFLICT(*YES)')                /*CUP022*/
/**********     CHGVAR     VAR(&CONFLICT) VALUE('*YES')                     */ /*CUP022*/ /*CUP021*/
                ACTIONFILE MODE(*CFT) FILE(&AUMBNM)                                       /*CUP021*/
             ENDDO
 
/* PROCESS  */                                                                            /*CUP022*/
             IF         COND(&MODE *EQ '*PROCESS') THEN(DO)
/**Take*security*copy.**/ /*                                                           */ /*CUP021*/
/**********     CHGVAR     VAR(&SECCOPY) VALUE('@' *TCAT &AABONF)                      */ /*CUP021*/
/**********     CPYF       FROMFILE(&AABONF) TOFILE(&DPLIB/&SECCOPY) +                 */ /*CUP021*/
/**********                  MBROPT(*REPLACE) CRTFILE(*YES)                            */ /*CUP021*/
/*****          CHGVAR     VAR(&CMD) VALUE(&AABONF *BCAT 'PROCESS(*YES)')   */ /*CUP022*/ /*CUP021*/
/**********     CHGVAR     VAR(&PROCESS) VALUE('*YES')                      */ /*CUP022*/ /*CUP021*/
                ACTIONFILE MODE(*PRC) FILE(&AUMBNM)                                       /*CUP021*/
             ENDDO
 
/**Call*Action*File*command.**/                                                           /*CUP022*/
/******      CALL       PGM(QCMDEXC) PARM(&CMD 100)                                       /*CUP022*/
 
/**Call*Action*File*command*program**/ /*                                   */ /*CUP022*/ /*CUP021*/
/**********  CALL       PGM(UPC000799) PARM(&AABONF &BUILD &REVIEW +                   */ /*CUP021*/
/**********               &CONFLICT &PROCESS &RESET &OLDLIB &NEWLIB +                  */ /*CUP021*/
/**********               &REVTYP)                                          */ /*CUP022*/ /*CUP021*/
/**********  MONMSG     MSGID(CPF0000)                                                 */ /*CUP021*/
/**If*an*error*then*end*program. */                                                       /*CUP022*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*If*error*in*processing*then*copy*security*back.**/ /*                                */ /*CUP021*/
/**********     IF         COND(&MODE *EQ '*PROCESS') THEN(DO)                         */ /*CUP021*/
/**********        CPYF       FROMFILE(&DPLIB/&SECCOPY) TOFILE(&AABONF) +              */ /*CUP021*/
/**********                     MBROPT(*REPLACE)                                       */ /*CUP021*/
/**********     ENDDO                                                                  */ /*CUP021*/
/* If an error, send error line and read next rec.     */                                 /*CUP022*/
                CHGJOB     SWS(XXXXXX00)                                                  /*CUP022*/
                CHGVAR     VAR(&ERROR) VALUE('Y')                                         /*CUP021*/
/**********     CHGVAR     VAR(&ERRORMSG) VALUE('Error when running +                  */ /*CUP021*/
/**********                  UPC000799 for' *BCAT &AABONF)                 */ /*CUP022*/  /*CUP021*/
                CHGVAR     VAR(&ERRORMSG) VALUE('Error when running +
                             UPC000799 for' *BCAT &AUMBNM)                                /*CUP021*/
                CALL       PGM(UP008010) PARM(*WRITE &GENPGM &ERRORMSG)                   /*CUP022*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                               /*CUP022*/
                   GOTO       CMDLBL(ABNOR)                                               /*CUP022*/
                ENDDO                                                                     /*CUP022*/
/*****          GOTO       CMDLBL(END)                                                    /*CUP022*/
             ENDDO
 
             GOTO       CMDLBL(READNEXT)
 
/*****       GOTO       CMDLBL(END)                                                       /*CUP022*/
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             GOTO       CMDLBL(ABNOREND)                                                  /*CUP022*/
 
END:
/* Call program to produce report. */                                                     /*CUP022*/
             IF         COND(&ERROR *EQ 'Y') THEN(DO)                                     /*CUP021*/
                CALL       PGM(UP008010) PARM(*REPORT &GENPGM ' ')                        /*CUP022*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                               /*CUP022*/
                   GOTO       CMDLBL(ABNOREND)                                            /*CUP022*/
                ENDDO                                                                     /*CUP022*/
/**********  CHGSPLFA   FILE(UP008010P1) SPLNBR(*LAST) USRDTA(&GENPGM)      */ /*CUP022*/ /*CUP021*/
                CHGSPLFA   FILE(UP008010P1) SPLNBR(*LAST) USRDTA(&MODE)                   /*CUP021*/
             ENDDO                                                                        /*CUP021*/
 
ABNOREND:                                                                                 /*CUP022*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
