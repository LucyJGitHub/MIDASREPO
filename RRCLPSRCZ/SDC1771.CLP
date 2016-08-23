/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Add LF Members for Multimember Files')          */
/********************************************************************/
/*                                                                  */
/*       Midas - Restart Recovery Module                            */
/*                                                                  */
/*       SDC1771  - ADD MEMBERS FROM MULTI MEMBER FILES             */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01408            DATE 10MAY95              */
/*       PREV AMEND NO. 086668            DATE 29MAR95              */
/*                      S01319            DATE 20SEP91              */
/*                      E25815            DATE 19JUL91              */
/*                      S01337            DATE 17APR91              */
/*                      BHF982            DATE 19FEB91              */
/*                      S01179            DATE 13/09/88             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*      S01408 - Addition of core hook SDC1771MPE                   */
/*      086668 - MISSING FOMATTING OF VARIABLE DMLIB                */
/*      S01319  -  Remove redundant processing                      */
/*      E25815 - IBM STANDARD FILE QAFDMBRL IS OVERRIDDEN TO        */
/*               PF/MEMB1 WHEN IT SHOULD BE OVERRIDDEN TO PF/MEMB.  */
/*             - IF ONE OF THE FILES PROCESSED TO PRODUCE PF/MEMB   */
/*               HAS NO MEMBERS THEN THE ADDLFM COMMAND WILL FALL   */
/*               OVER. &MLNAME SHOULD BE CHECKED FOR A NON-BLANK    */
/*               VALUE.                                             */
/*             - PF/FXPBLHPP IS IN THE DPLIB NOT THE DMLIB.         */
/*      S01337 - PHYSICAL FILE FXDWNBPP IS LOCATED IN 'DM' LIBRARY  */
/*               NOT THE 'D' LIBRARY. AMENDED TO REFERENCE THE      */
/*               'DM' LIBRARY FOLLOWING SPLIT OF THE 'D' LIBRARY    */
/*      BHF982  -  ADDLFM SHOULD BE SHARE(*YES)                     */
/*      S01179  -  AS400 CONVERSION                                 */
/*              - SPECIFY LIBRARY FOR ADDLFM COMMAND                */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
PGM
/**********  DCLDTAARA  DTAARA(MMOD)                                *  *S01179*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*S01179*/
/* START */                                                 /*S01179*/
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(9)
/************DCL        VAR(&DLIB)  TYPE(*CHAR) LEN(9)                 *S01337*/
             DCL        VAR(&DPLIB)  TYPE(*CHAR) LEN(9)               /*E25815*/
/*  END  */                                                 /*S01179*/
             DCLF       FILE(QAFDMBRL)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**********  RCVDTAARA  DTAARA(MMOD)                                *  *S01179*/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)                    /*S01179*/
/* FX PROCESSING */
             IF         COND(%SST(&MMOD 13 1) *EQ 'Y') THEN(DO)
/**GET*LIST*OF*MEMBERS*FOR*BLOTTER /********************************/ /*S01319*/
/************DSPFD****FILE(FXDWNBPP)*TYPE(*MBRLIST)*OUTPUT(*OUTFILE)/+/*S01319*/
/*************************OUTFILE(QTEMP/MEMB1)**********************/ /*S01319*/
/************OVRDBF     FILE(QAFDMBRL) TOFILE(QTEMP/MEMB1) ***/       /*E25815*/
/* GET LIST OF MEMBERS IN TRAILER*/                                   /*S01319*/
             DSPFD    FILE(FXTTOTPP) TYPE(*MBRLIST) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/MEMB1)                        /*S01319*/
 /* COPY OUTPUT TO MAIN FILE*/
             CPYF       FROMFILE(MEMB1) TOFILE(QTEMP/MEMB) +
                          MBROPT(*ADD) CRTFILE(*YES)
                                                                      /*E25815*/
/* ONCE PF/MEMB HAS BEEN CREATED - OVERRIDE TO IT */                  /*E25815*/
                                                                      /*E25815*/
             OVRDBF     FILE(QAFDMBRL) TOFILE(QTEMP/MEMB)             /*E25815*/
                                                                      /*E25815*/
/**DISPLAY*MEMBERS*IN*STANDARD*DEAL* /*****************************/  /*S01319*/
/************DSPFD***FILE(FXSTDDPP)*TYPE(*MBRLIST)*OUTPUT(*OUTFILE)*+ /*S01319*/
/*************************OUTFILE(QTEMP/MEMB1)**********************/ /*S01319*/
/**ADD*LIST*TO*MAIN*FILE* /****************************************/  /*S01319*/
/************CPYF*******FROMFILE(MEMB1)*TOFILE(QTEMP/MEMB)*+********/ /*S01319*/
/*************************MBROPT(*ADD)******************************/ /*S01319*/
/**DISPLAY*MEMBERS*IN*TRAILER*FILE* /******************************/  /*S01319*/
/************DSPFD***FILE(FXTTOTPP)*TYPE(*MBRLIST)*OUTPUT(*OUTFILE)*+ /*S01319*/
/*************************OUTFILE(QTEMP/MEMB1)**********************/ /*S01319*/
/**ADD*THESE*RECORD*TO*THE*MAIN*FILE* /*****************************/ /*S01319*/
/************CPYF*******FROMFILE(MEMB1)*TOFILE(QTEMP/MEMB)*+********/ /*S01319*/
/*************************MBROPT(*ADD)******************************/ /*S01319*/
/* DELETE THE TEMP FILE */
             DLTF       FILE(QTEMP/MEMB1)
/* OPEN THE FILE OF MEMBERS */
             OPNDBF     FILE(MEMB) OPTION(*INP)
/**READ*THE*FILE* /*************************************************/ /*S01319*/
/*FXDWNBPP:***RCVF**************************************************/ /*S01319*/
/**MONITOR*FOR*END*OF*FILE* /***************************************/ /*S01319*/
/************MONMSG*****MSGID(CPF0864)*EXEC(GOTO*CMDLBL(FXSTDDPP))**/ /*S01319*/
/************IF         COND(&MLFILE *EQ '         ') THEN(GOTO +
/************             CMDLBL(FXDWNBPP))                           /*E25815*/
/************IF*********COND((&MLFILE**EQ*'**********')*+***********/ /*S01319*/
/**************************OR*(&MLNAME**EQ*'**********'))*+*********/ /*S01319*/
/*************************THEN(GOTO*CMDLBL(FXDWNBPP))***** /*E25815*/ /*S01319*/
/**IF*THE*FILE*NAME*IS*FXSTDDPP*THEN*GO*TO*THE*PROCESSING* /********/ /*S01319*/
/**FOR*FXSTDDPP* /**************************************************/ /*S01319*/
/************IF*********COND(&MLFILE**EQ*'FXSTDDPP**')*THEN(GOTO*+**/ /*S01319*/
/*************************CMDLBL(FXSTDDP1))*************************/ /*S01319*/
/**IF*THE*FILE*NAME*IS*FXTTOTPP*THEN*GO*TO*THE*PROCESSING* /********/ /*S01319*/
/**FOR*FXTTOTPP* /**************************************************/ /*S01319*/
/************IF*********COND(&MLFILE**EQ*'FXTTOTPP**')*THEN(GOTO*+**/ /*S01319*/
/*************************CMDLBL(FXTTOTP1))*************************/ /*S01319*/
/**ADD*THE*LOGICAL*FILE*MEMBERS*BASED*OVER*FX*BLOTTER* /************/ /*S01319*/
/*START*S01179: /***************************************************/ /*S01319*/
/***************RTVDTAARA**DTAARA(SDSTAT)*RTNVAR(&SDSTAT)***********/ /*S01319*/
/***************CHGVAR***VAR(&DMLIB)*VALUE(%SST(&SDSTAT*6*2)**CAT*+*/ /*S01319*/
/******************************************'DMLIB')*****************/ /*S01319*/
/**********     CHGVAR   VAR(&DLIB) VALUE(%SST(&SDSTAT 6 2) *CAT +     *S01337*/
/**********                                'DLIB')                     *S01337*/
/************CHGVAR*****VAR(&DPLIB)*VALUE(%SST(&SDSTAT*6*2)**CAT*+**/ /*S01319*/
/*************************'DPLIB')************************ /*E25815*/ /*S01319*/
/**********  ADDLFM     FILE(FXDWNBLL) MBR(&MLNAME) DTAMBRS((FXDWNBPP +
                          (&MLNAME)))             */
/*           ADDLFM     FILE(FXDWNBLL) MBR(&MLNAME) +
                          DTAMBRS((&DLIB/FXDWNBPP (&MLNAME))) */      /*BHF982*/
/*********** ADDLFM     FILE(FXDWNBLL) MBR(&MLNAME) +
/***********              DTAMBRS((&DLIB/FXDWNBPP (&MLNAME))) +
/***********              SHARE(*YES)                       /*BHF982*  *S01337*/
/*********** ADDLFM     FILE(FXDWNBLL) MBR(&MLNAME) +                 /*S01319*/
/*************************DTAMBRS((&DMLIB/FXDWNBPP*(&MLNAME)))***+**/ /*S01319*/
/*************************SHARE(*YES)********************* /*S01337*/ /*S01319*/
/**********  ADDLFM     FILE(FXDWN2LL) MBR(&MLNAME) DTAMBRS((FXDWNBPP +
                          (&MLNAME)))             */
/*           ADDLFM     FILE(FXDWN2LL) MBR(&MLNAME) +
                          DTAMBRS((&DMLIB/FXDWNBPP (&MLNAME))) */     /*BHF982*/
/************ADDLFM*****FILE(FXDWN2LL)*MBR(&MLNAME)*+***************/ /*S01319*/
/*************************DTAMBRS((&DMLIB/FXDWNBPP*(&MLNAME)))*+****/ /*S01319*/
/*************************SHARE(*YES)******************** /*BHF982*/  /*S01319*/
/**********  ADDLFM     FILE(FXDW38LL) MBR(&MLNAME) DTAMBRS((FXDWNBPP +
                          (&MLNAME)))             */
/*           ADDLFM     FILE(FXDW38LL) MBR(&MLNAME) +
                          DTAMBRS((&DMLIB/FXDWNBPP (&MLNAME))) */     /*BHF982*/
/************ADDLFM*****FILE(FXDW38LL)*MBR(&MLNAME)*+***************/ /*S01319*/
/*************************DTAMBRS((&DMLIB/FXDWNBPP*(&MLNAME)))*+****/ /*S01319*/
/*************************SHARE(*YES)********************* /*BHF982*/ /*S01319*/
/**********  ADDLFM     FILE(FXPBLTLL) MBR(&MLNAME) DTAMBRS((FXDWNBPP +
                          (&MLNAME)) (FXPBLHPP (FXPBLHPP))) */
/*           ADDLFM     FILE(FXPBLTLL) MBR(&MLNAME) +
                          DTAMBRS((&DMLIB/FXDWNBPP (&MLNAME)) +
                          (&DMLIB/FXPBLHPP (FXPBLHPP))) */            /*BHF982*/
/************ADDLFM     FILE(FXPBLTLL) MBR(&MLNAME) +
/************             DTAMBRS((&DMLIB/FXDWNBPP (&MLNAME)) +
/************         (&DMLIB/FXPBLHPP (FXPBLHPP))) SHARE(*YES)/*BHF982*E25815*/
/*END*S01179 /******************************************************/ /*S01319*/
/************ADDLFM*****FILE(FXPBLTLL)*MBR(&MLNAME)*+***************/ /*S01319*/
/*************************DTAMBRS((&DMLIB/FXDWNBPP*(&MLNAME))*+*****/ /*S01319*/
/*****************(&DPLIB/FXPBLHPP*(FXPBLHPP)))*SHARE(*YES)/*E25815*/ /*S01319*/
/*******************************************************************/ /*S01319*/
/**READ*NEXT*RECORD* /**********************************************/ /*S01319*/
/************GOTO*******CMDLBL(FXDWNBPP)****************************/ /*S01319*/
/**READ*FILE*FOR*NAME*OF*MEMBER* /**********************************/ /*S01319*/
/*FXSTDDPP:**RCVF***************************************************/ /*S01319*/
/**MONITOR*FOR*END*OF*FILE* /***************************************/ /*S01319*/
/************MONMSG*****MSGID(CPF0864)*EXEC(GOTO*CMDLBL(FXTTOTPP))**/ /*S01319*/
/**IF*THE*FILE*NAME*IS*FXTTOTPP*THEN*GO*TO*THE*PROCESSING* /********/ /*S01319*/
/**FOR*FXTTOTPP* /**************************************************/ /*S01319*/
/************IF*********COND(&MLFILE**EQ*'FXTTOTPP**')*THEN(GOTO*+**/ /*S01319*/
/*************************CMDLBL(FXTTOTP1))*************************/ /*S01319*/
/**ADD*MEMBER*FOR*STANDARD*DEAL* /**********************************/ /*S01319*/
/* START S01179:*/
/*FXSTDDP1:  ADDLFM    FILE(FXSTDDLL) MBR(&MLNAME) DTAMBRS((FXSTDDPP +
                          (&MLNAME)))    */
/*FXSTDDP1:   ADDLFM     FILE(FXSTDDLL) MBR(&MLNAME) +
                          DTAMBRS((&DMLIB/FXSTDDPP (&MLNAME))) */     /*BHF982*/
/*FXSTDDP1:***ADDLFM*****FILE(FXSTDDLL)*MBR(&MLNAME)*+**************/ /*S01319*/
/*************************DTAMBRS((&DMLIB/FXSTDDPP*(&MLNAME)))*+****/ /*S01319*/
/*************************SHARE(*YES)******************** /*BHF982*/  /*S01319*/
/**END*S01179 /*****************************************************/ /*S01319*/
/*******************************************************************/ /*S01319*/
/**READ*NEXT*RECORD* /**********************************************/ /*S01319*/
/************GOTO*******CMDLBL(FXSTDDPP)****************************/ /*S01319*/
/* READ FILE FOR FXTTOTPP ENTRIES */
FXTTOTPP:  RCVF
/* MONITOR FOR END OF FILE */
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(FXEND))
/* ADD MEMBERS FOR FXTTOTLL */
/* START S01179:*/
/* FXTTOTP1: ADDLFM     FILE(FXTTOTLL) MBR(&MLNAME) DTAMBRS((FXTTOTPP +
                          (&MLNAME))) */
/*FXTTOTP1:   ADDLFM     FILE(FXTTOTLL) MBR(&MLNAME) +
                          DTAMBRS((&DMLIB/FXTTOTPP (&MLNAME)))  */    /*BHF982*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                /*086668*/
             CHGVAR     VAR(&DMLIB) VALUE(%SST(&SDSTAT 6 2) *CAT +
                          'DMLIB')                                    /*086668*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1771MPE                                          */
                                                                      /*S01408*/
 FXTTOTP1:  ADDLFM     FILE(FXTTOTLL) MBR(&MLNAME) +
                          DTAMBRS((&DMLIB/FXTTOTPP (&MLNAME))) +
                          SHARE(*YES)                                 /*BHF982*/
/* END S01179*/
/* READ NEXT RECORD */
             GOTO       CMDLBL(FXTTOTPP)
/* CLOSE THE FILE */
 FXEND:      CLOF       OPNID(MEMB)
 /* DELETE THE FILE OF MEMBERS */
             DLTF       FILE(QTEMP/MEMB)
             ENDDO
/* SKIP TO END OF PROGRAM */
             GOTO       CMDLBL(END)
 ABNOR:      SNDPGMMSG  MSG('Addition of logical file members ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
END:          ENDPGM
