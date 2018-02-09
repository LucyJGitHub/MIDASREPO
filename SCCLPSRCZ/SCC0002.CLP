/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Determine the level of the Midas system')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0002 - Determine the Level of the Midas System           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CUP023             Date 17Mar11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 27Sep01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      159708  *CREATE    Date 23Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP023 - Addition of sequence numbers for release levels    */
/*                (Recompile)                                        */
/*       CPK014 - Release 4 packaging:                               */
/*                - Amend the position of the release level number.  */
/*       159708 - Program to display release level at Midas          */
/*                initialisation.                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MLICL &MLIRL &MSYSL &MSIRL &MSGNUMBER)
 
/*/COPY WNCPYSRC,SCC0002INT                                          */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MLICL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MLICL2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSYSL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSYSL2) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MLIRL) TYPE(*CHAR) LEN(3)
/**********  DCL        VAR(&MSIRL) TYPE(*CHAR) LEN(3) */                                 /*CPK014*/
             DCL        VAR(&MSIRL) TYPE(*CHAR) LEN(27)                                   /*CPK014*/
             DCL        VAR(&AXRELL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AXIREL) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MSGNUMBER) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(SCRELHPD)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,SCC0002MPS                                          */
 
LOOP1:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(EOF))
 
/**********  CHGVAR     VAR(&MLICL2) VALUE(%SST(&AXRELL 6 1))                             /*CPK014*/
             CHGVAR     VAR(&MLICL2) VALUE(%SST(&AXRELL 10 1))                            /*CPK014*/
 
/* If licence Level is same as System Level save Licence Interim Release */
             IF         COND(&MLICL = &MLICL2) THEN(DO)
                CHGVAR     VAR(&MLIRL) VALUE(&AXIREL)
             ENDDO
 
/**As*long*as*System*Level*is*not*R10.*,*save*System*Release*Levels***/                   /*CPK014*/
/* As long as System Level is not R10.* or DBAR*, save System Release Levels */           /*CPK014*/
             CHGVAR     VAR(&MSYSL2) VALUE(%SST(&AXRELL 1 4))
 
/**********  IF         COND(&MSYSL2 *NE 'R10.') THEN(DO) */                              /*CPK014*/
             IF         COND((&MSYSL2 *NE 'R10.') *AND (&MSYSL2 *NE +
                          'DBAR')) THEN(DO)                                               /*CPK014*/
/**********     CHGVAR     VAR(&MSYSL) VALUE(%SST(&AXRELL 6 1))                           /*CPK014*/
/**********     CHGVAR     VAR(&MSIRL) VALUE(&AXIREL) */                                  /*CPK014*/
                CHGVAR     VAR(&MSYSL) VALUE(%SST(&AXRELL 10 1))                          /*CPK014*/
                CHGVAR     VAR(&MSIRL) VALUE(&AXIREL *TCAT &AXINFO)                       /*CPK014*/
             ENDDO
 
             GOTO       CMDLBL(LOOP1)
 
 EOF:
/* At end of file, if Licence Level still same as Release Levels,      */
/* copy Licence Release Level                                          */
/************CHGVAR     VAR(&MLICL2) VALUE(%SST(&AXRELL 6 1))                          */ /*CPK014*/
             CHGVAR     VAR(&MLICL2) VALUE(%SST(&AXRELL 10 1))                            /*CPK014*/
 
             IF         COND(&MLICL = &MLICL2) THEN(DO)
                CHGVAR     VAR(&MLIRL) VALUE(&AXIREL)
             ENDDO
 
/*/COPY WNCPYSRC,SCC0002MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Abnormal termination  */
 
/*/COPY WNCPYSRC,SCC0002ERR                                          */
 
             IF         COND(&MSGNUMBER *EQ '08') THEN(DO)
                CHGJOB     SWS(XXXXXX11)
             ENDDO
 
             SNDPGMMSG  MSG('Program SDC0002 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,SCC0002END                                          */
 
             ENDPGM
