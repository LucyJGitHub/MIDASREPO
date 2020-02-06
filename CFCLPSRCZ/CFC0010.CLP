/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CF Link branches to TRAM systems')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - CONFIRMATION MATCHING                       */
/*                                                                   */
/*       CFC0010 - LINK BRANCH TO TRAM SYSTEM                        */
/*       (CALLED BY CF0010)                                          */
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
/*       Prev Amend No. S01184             Date 15Dec89              */
/*                                         Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01184 - CREATED FOR CONFIRMATION MATCHING                  */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&SFX &VLD)
             DCL VAR(&SFX) TYPE(*CHAR) LEN(3)
             DCL VAR(&VLD) TYPE(*CHAR) LEN(1)
             DCL VAR(&FLR) TYPE(*CHAR) LEN(9)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/**  IF FOLDER 'CFFLR.&SFX' DOES NOT EXIST SET &VLD TO 'N'           */
             CHGVAR VAR(&FLR) VALUE('CFFLR.' *CAT &SFX)
             CPYTOPCD   FROMFILE(CFBUSYPD) TOFLR(&FLR) REPLACE(*YES)
             MONMSG MSGID(IWS16B6 IWS1612) EXEC(DO)
                CHGVAR VAR(&VLD) VALUE('N')
             ENDDO
 
/**  IF FOLDER 'CFFLR.&SFX' DOES EXIST REMOVE COPY                   */
             DLTDLO     DLO(CFBUSYPD) FLR(&FLR)
             MONMSG MSGID(CPF0000 IWS0000)
             GOTO END
 
 ABNOR:      SNDPGMMSG  MSG('CFC0010 ENDED ABNORMALLY') TOPGMQ(*EXT) +
                        TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
