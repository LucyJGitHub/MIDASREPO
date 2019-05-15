/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Midas initiation screen')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0001 - Midas Initiation Screen                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 27Sep01              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CPK010             Date 28Sep99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      159708             Date 23APR99              */
/*                      092825             Date 01SEP95              */
/*                      CAAA01  *CREATE    Date 12APR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK014 - Release 4 packaging:                               */
/*                - Declare missing variable &MLIRL.                 */
/*       CPK010 - DBA3 Alpha-site changes:                           */
/*                - Remove 'Interim Release' from Licence Level.     */
/*       159708 - Addition of Release level screen.                  */
/*       092825 - Addition of initialisation status messages.        */
/*       CAAA01 - GUI/400 Development:                               */
/*                - New program created for this development.        */
/*                                                                   */
/*********************************************************************/
/**********  PGM **/                                                  /*092825*/
             PGM        PARM(&MSGNUMBER)                              /*092825*/
 
/*/COPY WNCPYSRC,SCC0001INT                                          */
 
             DCL        VAR(&MSGNUMBER) TYPE(*CHAR) LEN(2)            /*092825*/
             DCL        VAR(&MLIRL) TYPE(*CHAR) LEN(3)                                    /*CPK014*/
             DCL        VAR(&MLIRL) TYPE(*CHAR) LEN(3)                /*CPK010*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCLF       FILE(SCC0001DF)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,SCC0001MPS                                          */
 
             CHGVAR     VAR(&IN01) VALUE('0')                         /*092825*/
             CHGVAR     VAR(&IN02) VALUE('0')                         /*092825*/
             CHGVAR     VAR(&IN03) VALUE('0')                         /*092825*/
             CHGVAR     VAR(&IN04) VALUE('0')                         /*092825*/
             CHGVAR     VAR(&IN05) VALUE('0')                         /*092825*/
             CHGVAR     VAR(&IN06) VALUE('0')                         /*092825*/
             CHGVAR     VAR(&IN07) VALUE('0')                         /*092825*/
             CHGVAR     VAR(&IN08) VALUE('0')                         /*159708*/
             CHGVAR     VAR(&MSYSL) VALUE('  ')                       /*159708*/
/**********  CHGVAR     VAR(&MSIRL) VALUE('   ') */                            /*159708*/ /*CPK014*/
             CHGVAR     VAR(&MSIRL) VALUE(' ')                                            /*CPK014*/
             CHGVAR     VAR(&MLICL) VALUE('  ')                       /*159708*/
             CHGVAR     VAR(&MLIRL) VALUE('   ')                      /*159708*/
                                                                      /*092825*/
/* Midas initiation in progress... */                                 /*092825*/
             IF         COND(&MSGNUMBER *EQ '01') THEN(CHGVAR +
                          VAR(&IN01) VALUE('1'))                      /*092825*/
                                                                      /*092825*/
/* User validation in progress... */                                  /*092825*/
             IF         COND(&MSGNUMBER *EQ '02') THEN(CHGVAR +
                          VAR(&IN02) VALUE('1'))                      /*092825*/
                                                                      /*092825*/
/* User language initialisation in progress... */                     /*092825*/
             IF         COND(&MSGNUMBER *EQ '03') THEN(CHGVAR +
                          VAR(&IN03) VALUE('1'))                      /*092825*/
                                                                      /*092825*/
/* Midas module initialisation in progress... */                      /*092825*/
             IF         COND(&MSGNUMBER *EQ '04') THEN(CHGVAR +
                          VAR(&IN04) VALUE('1'))                      /*092825*/
                                                                      /*092825*/
/* User initialisation in progress... */                              /*092825*/
             IF         COND(&MSGNUMBER *EQ '05') THEN(CHGVAR +
                          VAR(&IN05) VALUE('1'))                      /*092825*/
                                                                      /*092825*/
/* User action code extraction in progress... */                      /*092825*/
             IF         COND(&MSGNUMBER *EQ '06') THEN(CHGVAR +
                          VAR(&IN06) VALUE('1'))                      /*092825*/
                                                                      /*092825*/
/* User menu option extraction in progress... */                      /*092825*/
             IF         COND(&MSGNUMBER *EQ '07') THEN(CHGVAR +
                          VAR(&IN07) VALUE('1'))                      /*092825*/
                                                                      /*092825*/
/* Release Level display option  */                                   /*159708*/
             IF         COND(&MSGNUMBER *EQ '08') THEN(CHGVAR +
                          VAR(&IN08) VALUE('1'))                      /*159708*/
                                                                      /*159708*/
/* Call to determine DBA Release Licence level  */
             CALL       PGM(SCC0003) PARM(&MLICL &MSGNUMBER)          /*159708*/
 
/* Call to determine DBA Release System Level and Interim Releases */
             CALL       PGM(SCC0002) PARM(&MLICL &MLIRL &MSYSL +
                          &MSIRL &MSGNUMBER)                          /*159708*/
                                                                      /*159708*/
/* If this is not being called from MITEM */                          /*159708*/
             IF         COND(&IN08 *NE '1') THEN(DO)                  /*159708*/
                SNDF
             ENDDO                                                    /*159708*/
                                                                      /*159708*/
/* If this is being called from MITEM */                              /*159708*/
             IF         COND(&IN08 *EQ '1') THEN(DO)                  /*159708*/
                SNDRCVF                                               /*159708*/
             ENDDO                                                    /*159708*/
 
/*/COPY WNCPYSRC,SCC0001MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,SCC0001ERR                                          */
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,SCC0001END                                          */
 
             ENDPGM
