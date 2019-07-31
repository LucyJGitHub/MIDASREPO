/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MA Archive to microfiche tape')                 */
/*********************************************************************/
/*                                                                   */
/*  Midas - Microfiche/Optical Disk Archiving Module                 */
/*                                                                   */
/*  MAC0650  - COPY MICROFICHE TO TAPE CONTROL                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1097431          Date 05Apr13              */
/*                      CCB020             Date 06Aug12              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01382             Date 29Jul92              */
/*                      CPK008             Date 06Jun97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  AR1097431 - SCC0420 20001 in DLYW                                */
/*  CCB020 - COB Restructure - Secondary COB Infrastructure          */
/*  CLE134 - Past Due Call Loan Processing (Recompile)               */
/*  S01382 - OPTICAL DISK DEVELOPMENT                                */
/*           NEW PROGRAM CREATED FOR SAR                             */
/*         - THIS IS A REWRITTEN PROGRAM SIMILAR TO MAC0606B BUT     */
/*           REPLACES VERSION OF MAC0606B (MADE REDUNDANT)           */
/*         - INCLUDES E27260, LN1070, LN0970 FROM MRSPGM10_3         */
/*         - EXCLUDES OPTICAL DISK PROCESSING                        */
/*         - THIS PROGRAM WILL COPY MICROFICHE BUREAU FILES TO       */
/*           ARCHIVE TAPES                                           */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST')
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&CHK) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TDEV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TVOL) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TOWN) TYPE(*CHAR) LEN(14)
/*********** DCL        VAR(&TDEN) TYPE(*DEC) LEN(5 0) */             /*CPK008*/
             DCL        VAR(&TDEN) TYPE(*CHAR) LEN(5)                 /*CPK008*/
             DCL        VAR(&NOCP) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&RELN) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&BLLN) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&AINZ) TYPE(*CHAR) LEN(1)
 /********** DCL        VAR(&FICHE) TYPE(*CHAR) LEN(1)             */                  /*AR1097431*/
 
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&ID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ID6) TYPE(*CHAR) LEN(6)
             DCL        VAR(&L9) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(9 0)
             DCL        VAR(&EMSG) TYPE(*CHAR) LEN(80)
             DCL        VAR(&ERPY) TYPE(*CHAR) LEN(1)
 /********** DCL        VAR(&MACHK) TYPE(*CHAR) LEN(1)             */                     /*CCB020*/
             DCL        VAR(&MACHK) TYPE(*CHAR) LEN(1)                                 /*AR1097431*/
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(103) VALUE('Please +
                          mount an archiving tape on +
                          device           (copy   of  ),   enter C +
                          to cancel or G to continue.')
 
             DCL        VAR(&MSGM) TYPE(*CHAR) LEN(56) VALUE('There +
                          are no reports to be archived to +
                          Microfiche today.')
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
 
/**Microfiche*Module*active*=*(&FMT*54)*is*'Y'**/                                      /*AR1097431*/
/************************************************************/                         /*AR1097431*/
/**********  CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)*/                         /*AR1097431*/
/************************************************************/                         /*AR1097431*/
/**Database*error*handling**/                                                          /*AR1097431*/
/**Read*of*the*SDMMODPD*ICD*record*ended*in*error**/                                   /*AR1097431*/
/************************************************************/                         /*AR1097431*/
/**********  IF         COND(&RTCD *NE '       ') THEN(DO)  */                         /*AR1097431*/
/**********  GOTO       CMDLBL(ABNOR)                       */                         /*AR1097431*/
/**********  ENDDO                                          */                         /*AR1097431*/
/************************************************************/                         /*AR1097431*/
/**********  CHGVAR     VAR(&FICHE) VALUE(%SST(&FMT 54 1))       */                    /*AR1097431*/
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
 
/* If Microfiche Module active (&FICHE is 'Y'),read (SDMCFCPD)    +
   Microfiche ICD record via an access program AOMCFCR0          */
 
/****IF****     COND(&FICHE *EQ 'Y') THEN(DO)                    */                    /*AR1097431*/
 
             CALL       PGM(AOMCFCR0) PARM(&RTCD &OPTN &FMT)
 
/* Database error handling */
/* Read of the Microfiche ICD record ended in error */
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* Check if data exist on Microfiche bureau file (MAFICDPD),      +
   if no data do not copy (MAFICDPD) to a tape */
 
             DLTF       FILE(QTEMP/MAFICDPD1)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(MAFICDPD) TOFILE(QTEMP/MAFICDPD1) +
                          MBROPT(*ADD) CRTFILE(*YES) NBRRCDS(1)
 
/* Check completion message for number of records copied */
 
 NEXTM:
             RCVMSG     MSGTYPE(*ANY) RMV(*NO) MSGDTA(&DATA) MSGID(&ID)
             CHGVAR     VAR(&ID6) VALUE(%SUBSTRING(&ID 1 6))
             IF         COND(&ID6 *NE 'CPC295') THEN(GOTO +
                          CMDLBL(NEXTM))
             CHGVAR     VAR(&L9) VALUE(%SUBSTRING(&DATA 75 4))
             CALL       PGM(SC0491) PARM(&L9 &REC)
 
/* If no records are copied the send message and end program */
 
             IF         COND(&REC *EQ 000000000) THEN(DO)
             SNDMSG     MSG(&MSGM) TOMSGQ(MOPERQ)
 
 /**********     RTVDTAARA  DTAARA(MACHK) RTNVAR(&MACHK)   */                             /*CCB020*/
 /**********     IF         COND(&MACHK *EQ 'O') THEN(DO)  */                             /*CCB020*/
 /**********     CHGDTAARA  DTAARA(MACHK) VALUE('C')       */                             /*CCB020*/
 /**********     ENDDO                                     */                             /*CCB020*/
 /**********     ELSE (DO)                                 */                             /*CCB020*/
 /**********     CHGDTAARA  DTAARA(MACHK) VALUE('M')       */                             /*CCB020*/
 /**********     ENDDO                                     */                             /*CCB020*/
                 RTVDTAARA  DTAARA(MACHK) RTNVAR(&MACHK)                               /*AR1097431*/
                 IF         COND(&MACHK *EQ 'O') THEN(DO)                              /*AR1097431*/
                 CHGDTAARA  DTAARA(MACHK) VALUE('C')                                   /*AR1097431*/
                 ENDDO                                                                 /*AR1097431*/
                 ELSE (DO)                                                             /*AR1097431*/
                 CHGDTAARA  DTAARA(MACHK) VALUE('M')                                   /*AR1097431*/
                 ENDDO                                                                 /*AR1097431*/
 
             GOTO       CMDLBL(THEEND)
             ENDDO
 
 
             CHGVAR     VAR(&TDEV) VALUE(%SST(&FMT 11 10))
             CHGVAR     VAR(&TVOL) VALUE(%SST(&FMT 21 6))
             CHGVAR     VAR(&TOWN) VALUE(%SST(&FMT 27 14))
             CHGVAR     VAR(&TDEN) VALUE(%SST(&FMT 41 5))
             CHGVAR     VAR(&CHK) VALUE(%SST(&FMT 46 4))
             CHGVAR     VAR(&NOCP) VALUE(%SST(&FMT 50 1))
             CHGVAR     VAR(&RELN) VALUE(%SST(&FMT 51 3))
             CHGVAR     VAR(&BLLN) VALUE(%SST(&FMT 54 4))
             CHGVAR     VAR(&AINZ) VALUE(%SST(&FMT 82 1))
 
             CHGVAR     VAR(%SST(&MSG 42 10)) VALUE(&TDEV)
             CHGVAR     VAR(%SST(&MSG 63 1)) VALUE(&NOCP)
 
/* Do while 'current copy number'(&COUNT) is less than           +
/* 'number of copies'(&NOCP) on Microfiche ICD record (SDMCFCPD) */
 
 MFICH:
         IF         COND(&COUNT *LT &NOCP) THEN(DO)
 
/* Add 1 to 'current copy number'(&COUNT),                       +
/* Send message to MSGQ/MOPERQ requesting tape load using:       +
/* 'device name'(&TDEV),'number of copies'(&NOCP),'current       +
    copy number'(&COUNT) */
 
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             CHGVAR     VAR(%SST(&MSG 58 1)) VALUE(&COUNT)
 
             SNDUSRMSG  MSG(&MSG) VALUES('C' 'G') TOMSGQ(MOPERQ) +
                          MSGRPY(&ERPY)
             IF         COND(&ERPY *EQ 'C') THEN(GOTO CMDLBL(CANCEL))
 
 
/* If the automatic initialisation is 'Y', perform RETRY1,       +
   otherwise prompt user for initialisation */
 
             IF         COND(&AINZ *EQ 'Y') THEN(GOTO CMDLBL(RETRY1))
             ELSE       CMD(DO)
 
 RETRY2:
               CHKTAP     DEV(&TDEV) VOL(&TVOL)
 
               MONMSG     MSGID(CPF6718) EXEC(DO)
               SNDUSRMSG  MSG('Unable to allocate device. Retry if +
                            device becomes available or cancel (C +
                            R)') VALUES('C' 'R') TOMSGQ(MOPERQ) +
                            MSGRPY(&ERPY)
                 IF         COND(&ERPY *EQ 'C') THEN(GOTO CMDLBL(CANCEL))
                 ELSE       CMD(GOTO CMDLBL(RETRY2))
               ENDDO
 
               MONMSG     MSGID(CPF6720) EXEC(DO)
               SNDUSRMSG  MSG('Tape with volume ID ' *CAT &TVOL *CAT +
                            ' not found. Mount the correct tape. (C +
                            R)') VALUES('C' 'R') TOMSGQ(MOPERQ) +
                            MSGRPY(&ERPY)
                 IF         COND(&ERPY *EQ 'C') THEN(GOTO CMDLBL(CANCEL))
                 ELSE       CMD(GOTO CMDLBL(RETRY2))
               ENDDO
 
               MONMSG     MSGID(CPF6760) EXEC(DO)
               SNDUSRMSG  MSG('Device not ready. Mount volume with ID +
                            ' *CAT &TVOL *CAT ' on device and retry +
                            (C R)') VALUES('C' 'R') TOMSGQ(MOPERQ) +
                            MSGRPY(&ERPY)
                 IF         COND(&ERPY *EQ 'C') THEN(GOTO CMDLBL(CANCEL))
                 ELSE       CMD(GOTO CMDLBL(RETRY2))
               ENDDO
 
               MONMSG     MSGID(CPF6772) EXEC(DO)
               SNDUSRMSG  MSG('Cannot process mounted vol.Clean tape +
                            path & heads,& retry (C R)') VALUES('C' +
                            'R') TOMSGQ(MOPERQ) MSGRPY(&ERPY)
                 IF         COND(&ERPY *EQ 'C') THEN(GOTO CMDLBL(CANCEL))
                 ELSE       CMD(GOTO CMDLBL(RETRY2))
               ENDDO
 
               MONMSG     MSGID(CPF9814) EXEC(DO)
               SNDUSRMSG  MSG('Device not found. Mount volume with ID +
                            ' *CAT &TVOL *CAT ' on correct device +
                            and retry (C R)') VALUES('C' 'R') +
                            TOMSGQ(MOPERQ) MSGRPY(&ERPY)
                 IF         COND(&ERPY *EQ 'C') THEN(GOTO CMDLBL(CANCEL))
                 ELSE       CMD(GOTO CMDLBL(RETRY2))
               ENDDO
 
               MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)
               SNDUSRMSG  MSG('Please mount an archiving tape (C R)') +
                          VALUES('C' 'R') TOMSGQ(MOPERQ) MSGRPY(&ERPY)
                 IF         COND(&ERPY *EQ 'C') THEN(GOTO CMDLBL(CANCEL))
                 ELSE       CMD(GOTO CMDLBL(RETRY2))
               ENDDO
 
             ENDDO
 
 
/* Initialise the tape using:'device name'(&TDEV),'volume id'    +
   (&TVOL),'owner id'(&TOWN),'tape density'(&TDEN),'clear option'+
   (&CHK) from Microfiche ICD record (SDMCFCPD) */
 
 RETRY1:
               INZTAP     DEV(&TDEV) NEWVOL(&TVOL) NEWOWNID(&TOWN) +
                            VOL(*MOUNTED) CHECK(&CHK) DENSITY(&TDEN) +
                            ENDOPT(*REWIND) CLEAR(&CHK)
 
               MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)
               RCVMSG     MSG(&EMSG)
               CHGVAR     VAR(&EMSG) VALUE(&EMSG *TCAT '  (C R) ')
               SNDUSRMSG  MSG(&EMSG) VALUES('C' 'R') TOMSGQ(MOPERQ) +
                          MSGRPY(&ERPY)
               IF         COND(&ERPY *EQ 'C') THEN(GOTO CMDLBL(CANCEL))
               GOTO       CMDLBL(RETRY1)
               ENDDO
 
/* Copy microfiche bureau file(MAFICDPD) to the tape using:         +
   'device name'(&TDEV),'record length'(&RELN),'block length'(BLLN) +
   from Microfiche ICD record (SDMCFCPD) */
 
             CPYTOTAP   FROMFILE(MAFICDPD) TOFILE(MATAPF) +
                          TOSEQNBR(*END) TOLABEL(FICHE) +
                          TODEV(&TDEV) TORCDLEN(&RELN) +
                          TOENDOPT(*REWIND) TOBLKLEN(&BLLN) +
                          TORCDBLK(*FB)
 
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)
             RCVMSG     MSG(&EMSG)
             CHGVAR     VAR(&EMSG) VALUE(&EMSG *TCAT '  (C R) ')
             SNDUSRMSG  MSG(&EMSG) VALUES('C' 'R') TOMSGQ(MOPERQ) +
                        MSGRPY(&ERPY)
               IF         COND(&ERPY *EQ 'C') THEN(GOTO CMDLBL(CANCEL))
               GOTO       CMDLBL(RETRY1)
               ENDDO
 
             GOTO       CMDLBL(MFICH)
 
         ENDDO
 
 /********** RTVDTAARA  DTAARA(MACHK) RTNVAR(&MACHK)     */                               /*CCB020*/
 /********** IF         COND(&MACHK *EQ 'O') THEN(DO)    */                               /*CCB020*/
 /********** CHGDTAARA  DTAARA(MACHK) VALUE('C')         */                               /*CCB020*/
 /********** ENDDO                                       */                               /*CCB020*/
 /********** ELSE       CMD(DO)                          */                               /*CCB020*/
 /********** CHGDTAARA  DTAARA(MACHK) VALUE('M')         */                               /*CCB020*/
 /********** ENDDO                                       */                               /*CCB020*/
             RTVDTAARA  DTAARA(MACHK) RTNVAR(&MACHK)                                   /*AR1097431*/
             IF         COND(&MACHK *EQ 'O') THEN(DO)                                  /*AR1097431*/
             CHGDTAARA  DTAARA(MACHK) VALUE('C')                                       /*AR1097431*/
             ENDDO                                                                     /*AR1097431*/
             ELSE       CMD(DO)                                                        /*AR1097431*/
             CHGDTAARA  DTAARA(MACHK) VALUE('M')                                       /*AR1097431*/
             ENDDO                                                                     /*AR1097431*/
 
 /***ENDDO**                                             */                            /*AR1097431*/
 
 GOTO  CMDLBL(THEEND)
 
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
 
/* If job cancelled by user send message and end program */
 
 CANCEL:     CHGJOB     SWS(XXXXXXX1)
             SNDMSG     MSG('Copy archive to tape job ended by +
                          user.') TOMSGQ(MOPERQ)
             GOTO       CMDLBL(THEEND)
 
/* Abnormal termination */
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
             SNDMSG     MSG('Copy Archive to tape ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000)
 
 THEEND:     ENDPGM
