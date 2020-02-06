/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL File and pgm shut down cont for DL3100')     */
/********************************************************************/
/*                                                                  */
/* Midas - FRA/IRS Module                                   */
/*                                                                  */
/* DLC3100 - FILE AND PROGRAM SHUT DOWN CONTROL FOR DL3100          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG11648           Date 28Jun06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      185680             Date 06Jun01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CEU012             Date 16Feb98              */
/*                      E24374             Date 23Sep91              */
/*                      S01157             Date 05Oct88              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG11648 - Create data area DLSDS for linked enquiries.    */
/*       185680 - Only 1 user can enter in this pgm .               */
/*       CEU012 - EMU Position/Risk Enquiries                        */
/*       E24374 - JOB SWITCHES U7-U8 SHOULD BE SET OFF AT THE       */
/*                BEGINNING SO THAT AN ERROR IN AN EARLIER PROGRAM  */
/*                DOES NOT AFFECT PROGRAMS CALLED BY THIS COMPONENT.*/
/*                                                                  */
/*       S01157 - NEW PROGRAM FOR FRA/IRS PROJECT                   */
/*                                                                  */
/********************************************************************/
/*                                                                   */
             PGM        PARM(&PARM)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CEU012) TYPE(*CHAR) LEN(7) VALUE('N')    /*CEU012*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CEU012*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CEU012*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CEU012*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CEU012*/
 
             CHGJOB     SWS(XXXXXX00)                                 /*E24374*/
             CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(167)                        /*BUG11648*/
             MONMSG     MSGID(CPF0000)                                                  /*BUG11648*/
/**/                                                                  /*CEU012*/
/** Check if SAR CEU012 is installed */                               /*CEU012*/
/**/                                                                  /*CEU012*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU012*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CEU012*/
             CHGVAR     VAR(&SARD) VALUE('CEU012')                    /*CEU012*/
             CALL      PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)     /*CEU012*/
/**/                                                                  /*CEU012*/
/** If CEU012 is installed  */                                        /*CEU012*/
/**/                                                                  /*CEU012*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CEU012) VALUE('Y'))                    /*CEU012*/
/**/                                                                  /*CEU012*/
/** If an error occured */                                            /*CEU012*/
/**/                                                                  /*CEU012*/
             IF         COND((&RTCD *NE '       ') *AND (&RTCD *NE +
                          '*NRF    ')) THEN(DO)                       /*CEU012*/
               SNDPGMMSG  MSG('AOSARDR0 - Program Error') +
                TOMSGQ(MOPERQ)                                        /*CEU012*/
               CHGJOB     SWS('XXXXXX11')                             /*CEU012*/
               GOTO       CMDLBL(EXIT)                                /*CEU012*/
             ENDDO                                                    /*CEU012*/
/**/                                                                  /*CEU012*/
/** If DL1912  proccess the PF/DLIRSEPD */                            /*CEU012*/
/**/                                                                  /*CEU012*/
             IF         COND((&CEU012 *EQ 'Y') *AND (&PARM *EQ +
                          'DL1912')) THEN(DO)                         /*CEU012*/
               OVRDBF     FILE(DLIRSEPD) SHARE(*NO)                   /*CEU012*/
               MONMSG     MSGID(CPF0000)                              /*CEU012*/
               OPNQRYF    FILE((DLIRSSPP) (SDCURRPD)) FORMAT+
                (DLIRSEPD) KEYFLD((*MAPFLD/KGSSNB *ASCEND) +
                (DLIRSSPP/KGCCY)) JFLD((DLIRSSPP/KGCCY SDCURRPD/+
                A6CYCD)) MAPFLD((KGSSNB A6SSNB) (KGINCY A6INCY))      /*CEU012*/
               ALCOBJ     OBJ((DLIRSEPD *FILE *EXCL)) WAIT(0)         /*185680*/
               MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(NOCPY))     /*185680*/
               CPYFRMQRYF FROMOPNID(DLIRSSPP) TOFILE(DLIRSEPD) +
                MBROPT(*REPLACE)                                      /*CEU012*/
               MONMSG     MSGID(CPF2909)                              /*CEU012*/
               DLCOBJ     OBJ((DLIRSEPD *FILE *EXCL))                 /*185680*/
NOCPY:                                                                /*185680*/
               CLOF       OPNID(DLIRSSPP)                             /*CEU012*/
               DLTOVR     FILE(DLIRSEPD)                              /*CEU012*/
               MONMSG     MSGID(CPF0000)                              /*CEU012*/
             ENDDO                                                    /*CEU012*/
/**/                                                                  /*CEU012*/
/** If DL1905/DL1902/DL1909  proccess the PF/DLFRBEPD */              /*CEU012*/
/**/                                                                  /*CEU012*/
             IF         COND(((&CEU012 *EQ 'Y') *AND (&PARM *EQ +
                          'DL1905')) *OR ((&CEU012 *EQ 'Y') *AND +
                          (&PARM *EQ 'DL1909')) *OR ((&CEU012 *EQ +
                          'Y') *AND (&PARM *EQ 'DL1902'))) THEN(DO)   /*CEU012*/
               OVRDBF     FILE(DLFRBEPD) SHARE(*NO)                   /*CEU012*/
               MONMSG     MSGID(CPF0000)                              /*CEU012*/
               OPNQRYF    FILE((DLDSMBPP) (SDCURRPD)) FORMAT+
                (DLFRBEPD) KEYFLD((*MAPFLD/KCSSNB *ASCEND) +
                (DLDSMBPP/KCCCY)) JFLD((DLDSMBPP/KCCCY SDCURRPD/+
                A6CYCD)) MAPFLD((KCSSNB A6SSNB) (KCINCY A6INCY))      /*CEU012*/
               ALCOBJ     OBJ((DLFRBEPD *FILE *EXCL)) WAIT(0)         /*185680*/
               MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(NOCPY1))    /*185680*/
               CPYFRMQRYF FROMOPNID(DLDSMBPP) TOFILE(DLFRBEPD) +
                MBROPT(*REPLACE)                                      /*CEU012*/
               MONMSG     MSGID(CPF2909)                              /*CEU012*/
               DLCOBJ     OBJ((DLFRBEPD *FILE *EXCL))                 /*185680*/
NOCPY1:                                                               /*185680*/
               CLOF       OPNID(DLDSMBPP)                             /*CEU012*/
               DLTOVR     FILE(DLFRBEPD)                              /*CEU012*/
               MONMSG     MSGID(CPF0000)                              /*CEU012*/
             ENDDO                                                    /*CEU012*/
/**/                                                                  /*CEU012*/
/** If DL1902/DL1909 proccess the PF/DLFRAEPD */                      /*CEU012*/
/**/                                                                  /*CEU012*/
             IF         COND(((&CEU012 *EQ 'Y') *AND (&PARM *EQ +
                          'DL1902')) *OR ((&CEU012 *EQ 'Y') *AND +
                          (&PARM *EQ 'DL1909'))) THEN(DO)             /*CEU012*/
               OVRDBF     FILE(DLFRAEPD) SHARE(*NO)                   /*CEU012*/
               MONMSG     MSGID(CPF0000)                              /*CEU012*/
               OPNQRYF    FILE((DEALSDG) (SDCURRPD)) FORMAT+
                (DLFRAEPD) KEYFLD((*MAPFLD/SSNB *ASCEND) +
                (DEALSDG/UCUCY)) JFLD((DEALSDG/UCUCY SDCURRPD/+
                A6CYCD)) MAPFLD((SSNB A6SSNB) (INCY A6INCY))          /*CEU012*/
               ALCOBJ     OBJ((DLFRAEPD *FILE *EXCL)) WAIT(0)         /*185680*/
               MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(NOCPY2))    /*185680*/
               CPYFRMQRYF FROMOPNID(DEALSDG) TOFILE(DLFRAEPD) +
                MBROPT(*REPLACE)                                      /*CEU012*/
               MONMSG     MSGID(CPF2909)                              /*CEU012*/
               DLCOBJ     OBJ((DLFRAEPD *FILE *EXCL))                 /*185680*/
NOCPY2:                                                               /*185680*/
               CLOF       OPNID(DEALSDG)                              /*CEU012*/
               DLTOVR     FILE(DLFRAEPD)                              /*CEU012*/
               MONMSG     MSGID(CPF0000)                              /*CEU012*/
             ENDDO                                                    /*CEU012*/
/* */
/* CALL BACK OFFICE STACKED ENQUIRY CONTROL */
/* */
             CALL       PGM(DL3100) PARM(&PARM)
EXIT:                                                                 /*CEU012*/
/* */
/* SHUT DOWN ALL PROGRAMS AND FILES USED BY DL3100 */
/* */
             RCLRSC
/* */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
