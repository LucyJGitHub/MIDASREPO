/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Add logical file member')                    */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC0130  -  ADD LOGICAL FILE MEMBER TO FILES                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. 178066             Date 10Apr00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   Last Amend No. E18445             DATE 22/08/89                 */
/*                  S01179             DATE 02/11/88                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CHANGE DESCRIPTIONS                                           */
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   178066 - File names can now be up to 10 long - need to extend   */
/*            array elements and variable definitions to allow for   */
/*            this.                                                  */
/*   E18445  -  TO ENSURE CREATION OF ALL LOGICAL FILE MEMBERS,      * *E18445*/
/*              CHANGES FOR S01179 HAVE BEEN REMOVED.                * *E18445*/
/*   S01179  -  AS400 CHANGES. ADDLFM NOW NEEDS LIBRARY SPECIFIED    */
/*              FOR THE PHYSICAL FILES. IT HAS BEEN ASSUMED THAT     */
/*              THE FILES ARE IN THE XXDMLIB.                        */
/*                                                                   */
/*********************************************************************/
             PGM (&MRKT &IND)
/**/
/* Declare Variables                                                */
/**/
             DCL        VAR(&X) TYPE(*DEC) LEN(2 0) VALUE(0)
             DCL        VAR(&Y) TYPE(*DEC) LEN(3 0) VALUE(0)
             DCL        VAR(&C) TYPE(*DEC) LEN(4 0) VALUE(1)
/*********** DCL        VAR(&LFIL) TYPE(*CHAR) LEN(8)                 *178066*/
/*********** DCL        VAR(&PFL1) TYPE(*CHAR) LEN(8)                 *178066*/
/*********** DCL        VAR(&PFL2) TYPE(*CHAR) LEN(8)                 *178066*/
/*********** DCL        VAR(&PFL3) TYPE(*CHAR) LEN(8)                 *178066*/
             DCL        VAR(&LFIL) TYPE(*CHAR) LEN(10)               /*178066*/
             DCL        VAR(&PFL1) TYPE(*CHAR) LEN(10)               /*178066*/
             DCL        VAR(&PFL2) TYPE(*CHAR) LEN(10)               /*178066*/
             DCL        VAR(&PFL3) TYPE(*CHAR) LEN(10)               /*178066*/
/* START */                                                /* S01179   E18445 */
/**********  DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)                     */
/**********  DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(7)                       */
/*  END  */                                                 /*S01179   E18445 */
/**/
/* Declare parameters                                               */
/**/
             DCL        VAR(&MRKT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&IND) TYPE(*CHAR) LEN(1)
             DCLF       FILE(FFMMFD)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,FFC0130001                                          */
/**/
/* CLEAR PHYSICAL FILE MEMBER                                       */
/**/
             OVRDBF     FILE(FFMMFD) SHARE(*NO)
             CLRPFM     FILE(FFMMFD)
/*/COPY WNCPYSRC,FFC0130002                                          */
/* START */                                                 /*S01179   E18445 */
/**/                                                                /*        */
/**********  RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)                        */
/**********  CHGVAR   VAR(&DMLIB) VALUE(%SST(&SDSTAT 6 2) *CAT +              */
/**********                                'DMLIB')                           */
/*  END  */                                                 /*S01179   E18445 */
/**/
/* CALL FF0002 - Set Up Multi-member Logical Files list              */
/**/
LOOP1:       CALL       PGM(FF0002) PARM('L' &C)
/**/
             RCVF
             CHGVAR VAR(&X) VALUE(0)
/**/
/*OOP2:******CHGVAR VAR(&LFIL)LVALUE(%SST(&FMMF &Y 8))        178066*/
/************CHGVAR VAR(&Y)IVALUE(&Y+8)ST(&FMMF &Y 8))        178066*/
/************CHGVAR VAR(&PFL1)LVALUE(%SST(&FMMF &Y 8))        178066*/
/************CHGVAR VAR(&Y)LVALUE(&Y+8)ST(&FMMF &Y 8))        178066*/
/************CHGVAR VAR(&PFL2)LVALUE(%SST(&FMMF &Y 8))        178066*/
/************CHGVAR VAR(&Y)LVALUE(&Y+8)ST(&FMMF &Y 8))        178066*/
/************CHGVAR VAR(&PFL3)LVALUE(%SST(&FMMF &Y 8))        178066*/
/**/
 LOOP2:      CHGVAR VAR(&Y) VALUE((40*&X)+1)
             CHGVAR VAR(&LFIL) VALUE(%SST(&FMMF &Y 10))     /*178066*/
             CHGVAR VAR(&Y) VALUE(&Y+10)                    /*178066*/
             CHGVAR VAR(&PFL1) VALUE(%SST(&FMMF &Y 10))     /*178066*/
             CHGVAR VAR(&Y) VALUE(&Y+10)                    /*178066*/
             CHGVAR VAR(&PFL2) VALUE(%SST(&FMMF &Y 10))     /*178066*/
             CHGVAR VAR(&Y) VALUE(&Y+10)                    /*178066*/
             CHGVAR VAR(&PFL3) VALUE(%SST(&FMMF &Y 10))     /*178066*/
                                                            /*178066*/
             IF  COND(&LFIL *NE ' ') THEN(DO)
/**/
/*  LOGICAL BASED ON 3 PHYSICALS     */
/**/
             IF  COND(&PFL3 *NE ' ') THEN(DO)
/* START */                                                 /*S01179*/
/**********  ADDLFM     FILE(&LFIL) MBR(&MRKT) DTAMBRS((&PFL1 +       */
/**********               (&MRKT)) (&PFL2 (&MRKT)) (&PFL3 (&MRKT))) + */
/**********               SHARE(*YES)                                 */
/**/
/* START */                                                 /*E18445*/
/**********  ADDLFM     FILE(&LFIL) MBR(&MRKT) DTAMBRS((&DMLIB/&PFL1+ */
/**********               (&MRKT)) (&DMLIB/&PFL2 (&MRKT)) +           */
/**********               (&DMLIB/&PFL3 (&MRKT))) SHARE(*YES)         */
/*  END  */                                                 /*S01179*/
             ADDLFM     FILE(&LFIL) MBR(&MRKT) DTAMBRS((&PFL1 +
                          (&MRKT)) (&PFL2 (&MRKT)) (&PFL3 (&MRKT))) +
                          SHARE(*YES)
/*  END  */                                                 /*E18445*/
             MONMSG     MSGID(CPF7306)
             ENDDO
/**/
/*   LOGICAL BASED ON 2 PHYSICALS    */
/**/
             IF         COND(&PFL3 *EQ ' ' *AND &PFL2 *NE ' ') THEN(DO)
/* START */                                                 /*S01179*/
/**********  ADDLFM     FILE(&LFIL) MBR(&MRKT) DTAMBRS((&PFL1 +     */
/**********               (&MRKT)) (&PFL2 (&MRKT))) SHARE(*YES)     */
/**/
/* START */                                                 /*E18445*/
/**********  ADDLFM     FILE(&LFIL) MBR(&MRKT) DTAMBRS((&DMLIB/&PFL1 + */
/**********               (&MRKT)) (&DMLIB/&PFL2 (&MRKT))) SHARE(*YES) */
/*  END  */                                                 /*S01179*/
             ADDLFM     FILE(&LFIL) MBR(&MRKT) DTAMBRS((&PFL1 +
                          (&MRKT)) (&PFL2 (&MRKT))) SHARE(*YES)
/*  END  */                                                 /*E18445*/
             MONMSG     MSGID(CPF7306)
             ENDDO
/**/
/*   LOGICAL BASED ON 1 PHYSICAL     */
/**/
             IF         COND(&PFL2 *EQ ' ') THEN(DO)
/* START */                                                 /*S01179*/
/**********  ADDLFM     FILE(&LFIL) MBR(&MRKT) DTAMBRS((&PFL1 +     */
/**********               (&MRKT))) SHARE(*YES)                     */
/**/
/* START */                                                 /*E18445*/
/**********  ADDLFM     FILE(&LFIL) MBR(&MRKT) DTAMBRS((&DMLIB/&PFL1 + */
/**********               (&MRKT))) SHARE(*YES)                        */
/*  END  */                                                 /*S01179*/
/*/COPY WNCPYSRC,FFC0130003                                          */
             ADDLFM     FILE(&LFIL) MBR(&MRKT) DTAMBRS((&PFL1 +
                          (&MRKT))) SHARE(*YES)
/*  END  */                                                 /*E18445*/
             MONMSG     MSGID(CPF7306)
/*/COPY WNCPYSRC,FFC0130004                                          */
             ENDDO
/**/
             IF         COND(&X *NE 15) THEN(DO)
             CHGVAR VAR(&X) VALUE(&X+1)
             GOTO LOOP2
             ENDDO
/**/
             CHGVAR VAR(&C) VALUE(&C+64)
             GOTO LOOP1
/**/
             ENDDO
/**/
/*                                                                  */
 END:        RCLRSC
             DLTOVR     FILE(FFMMFD)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
