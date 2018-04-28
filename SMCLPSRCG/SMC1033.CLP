/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SM Build up job description library list')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Implementation module                               */
/*                                                                   */
/*       SMC1033 - Build up job desription library list              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2003           */
/*                                                                   */
/*       Last Amend No. AR886414           Date 05Jan12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP025             Date 01Dec03              */
/*                      CUP016 *CREATE     Date 01Apr03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR886414 - Creation of CBS, CBA and BF libraries in SMSETUPD*/
/*                  not catered                                      */
/*       CUP025 - MidasPlus Bridge changes.                          */
/*       CUP016 - Add implementation software to core.               */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&JOBD &XLIB)                                              */ /*CUP025*/
             PGM        PARM(&JOBD &XLIB &LAYER &GXLIB)                                   /*CUP025*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
             DCL        VAR(&JOBD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LAYER) TYPE(*CHAR) LEN(7)                                    /*CUP025*/
             DCL        VAR(&GXLIB) TYPE(*CHAR) LEN(10)                                   /*CUP025*/
             DCL        VAR(&CURXLIB) TYPE(*CHAR) LEN(10)                                 /*CUP025*/
 
/* Parameters for QCLSCAN. */
             DCL        VAR(&STRLEN) TYPE(*DEC) LEN(3 0) VALUE(10)
             DCL        VAR(&STRPOS) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&PATTERN) TYPE(*CHAR) LEN(2) VALUE('**')
             DCL        VAR(&PATTERN2) TYPE(*CHAR) LEN(2) VALUE('##')                   /*AR886414*/
             DCL        VAR(&PATLEN) TYPE(*DEC) LEN(2) VALUE(2)
             DCL        VAR(&TRANSLATE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TRIM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WILD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RESULT) TYPE(*DEC) LEN(3)
 
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COMMAND) TYPE(*CHAR) LEN(3000) +
                          VALUE('CHGJOBD JOBD(')
             DCL        VAR(&FIRST) TYPE(*CHAR) LEN(4) VALUE('*YES')
             DCL        VAR(&LIBGRP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIBGRP2) TYPE(*CHAR) LEN(2)                                /*AR886414*/
             DCL        VAR(&INLLIBL) TYPE(*CHAR) LEN(2750)                               /*CUP025*/
/**********  DCL        VAR(&STRPOS) TYPE(*DEC) LEN(5 0) VALUE(1)                      */ /*CUP025*/
 
             DCLF       FILE(SMLIBLPD)
 
             IF         COND(&LAYER *EQ '*ZONE') THEN(DO)                                 /*CUP025*/
                CHGVAR     VAR(&LIBGRP) VALUE(%SST(&XLIB 1 2))
                CHGVAR     VAR(&LIBGRP2) VALUE(%SST(&GXLIB 1 2))                        /*AR886414*/
                CHGVAR     VAR(&CURXLIB) VALUE(&XLIB)                                     /*CUP025*/
             ENDDO                                                                        /*CUP025*/
             IF         COND(&LAYER *EQ '*GLOBAL') THEN(DO)                               /*CUP025*/
                CHGVAR     VAR(&LIBGRP) VALUE(%SST(&GXLIB 1 2))                           /*CUP025*/
                CHGVAR     VAR(&CURXLIB) VALUE(&GXLIB)                                    /*CUP025*/
             ENDDO                                                                        /*CUP025*/
 
/* Copy only library records from original driving file. */
             CPYF       FROMFILE(SMSETUL1) TOFILE(SMLIBLPD) +
                          MBROPT(*REPLACE) INCCHAR(DFTYPE 1 *EQ +
                          '*LIB      ') FMTOPT(*MAP *DROP)
 
/* Build up the next step of the command to execute. */
/**********  CHGVAR     VAR(&COMMAND) VALUE(&COMMAND *TCAT &XLIB +                     */ /*CUP025*/
/**********               *TCAT '/' *TCAT &JOBD *TCAT ') INLLIBL(')                    */ /*CUP025*/
             CHGVAR     VAR(&COMMAND) VALUE(&COMMAND *TCAT &CURXLIB +
                          *TCAT '/' *TCAT &JOBD *TCAT ') INLLIBL(')                       /*CUP025*/
READNEXT:
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(DO)
                GOTO       CMDLBL(CHGJOBD)
             ENDDO
 
/* Change '**' on driving file to equal system prefix ID. */
             CALL       PGM(QCLSCAN) PARM(&DFNAME &STRLEN &STRPOS +
                          &PATTERN &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)
             IF         COND(&RESULT *GT 0) THEN(DO)
                CHGVAR     VAR(%SST(&DFNAME &RESULT 2 )) VALUE(&LIBGRP)
             ENDDO
 
/** Change '##' on driving file to equal system prefix ID. */                           /*AR886414*/
             IF         COND(&LAYER *EQ '*ZONE') THEN(DO)                               /*AR886414*/
             CALL       PGM(QCLSCAN) PARM(&DFNAME &STRLEN &STRPOS +
                          &PATTERN2 &PATLEN &TRANSLATE &TRIM &WILD +
                          &RESULT)                                                      /*AR886414*/
             IF         COND(&RESULT *GT 0) THEN(DO)                                    /*AR886414*/
                CHGVAR     VAR(%SST(&DFNAME &RESULT 2 )) VALUE(&LIBGRP2)                /*AR886414*/
             ENDDO                                                                      /*AR886414*/
             ENDDO                                                                      /*AR886414*/
                                                                                        /*AR886414*/
             CHGVAR     VAR(&LIB) VALUE(&DFNAME)
             IF         COND(&FIRST *EQ '*YES') THEN(DO)
                CHGVAR     VAR(&COMMAND) VALUE(&COMMAND *TCAT &LIB)
                CHGVAR     VAR(&FIRST) VALUE('*NO ')
             ENDDO
             ELSE       CMD(DO)
                CHGVAR     VAR(&COMMAND) VALUE(&COMMAND *BCAT &LIB)
             ENDDO
 
/* Change start position for the addition of Global layer library list. */                /*CUP025*/
/*           CHGVAR     VAR(&STRPOS) VALUE(&STRPOS + 10)     */                           /*CUP025*/
 
             GOTO       CMDLBL(READNEXT)
 
CHGJOBD:
/* If creating a library list for a zone then add in Global layer. */                     /*CUP025*/
             IF         COND(&LAYER *EQ '*ZONE') THEN(DO)                                 /*CUP025*/
                RTVJOBD    JOBD(&GXLIB/GPBATCH) INLLIBL(&INLLIBL)                         /*CUP025*/
                CHGVAR     VAR(&COMMAND) VALUE(&COMMAND *BCAT &INLLIBL)                   /*CUP025*/
             ENDDO                                                                        /*CUP025*/
 
/* As long as one library was found then perform CHGJOBD. */
             IF         COND(&FIRST *EQ '*NO') THEN(DO)
                CHGVAR     VAR(&COMMAND) VALUE(&COMMAND *TCAT ')')
                CALL       PGM(QCMDEXC) PARM(&COMMAND 3000)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/* Abnormal program end. */
ABNOR:
             CHGJOB     SWS(XXXXXX11)
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
