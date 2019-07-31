/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Retail Detailed Accrual Extract')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC3666B - Retail Detailed Accrual Extract                  */
/*                                                                   */
/*       (c) Finastra International Limited 2006                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL075  *CREATE    Date 16Jun06              */
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL075 - Detailed Accrual Summary                           */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&POST)
 
             DCLF       FILE(TABTBRE)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2006')
             DCL        VAR(&POST) TYPE(*CHAR) LEN(1)
 
 /* Processing for Posting Indicator = '1' */
 
             IF         COND(&POST *EQ '1') THEN(DO)
 
             IF         COND(&ACSM *EQ 'Y') THEN(DO)
             CPYF       FROMFILE(GEIERPD0) TOFILE(REACRPPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
             IF         COND(&ACSM *NE 'Y') THEN(DO)
             CPYF       FROMFILE(GEIERPD) TOFILE(REACRPPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
             ENDDO
 
 /* Processing for Posting Indicator = '5' */
 
             IF         COND(&POST *EQ '5') THEN(DO)
 
             IF         COND(&ACSM *EQ 'Y') THEN(DO)
             CPYF       FROMFILE(GEIER2PD0) TOFILE(REACRPPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
             IF         COND(&ACSM *NE 'Y') THEN(DO)
             CPYF       FROMFILE(GEIER2PD) TOFILE(REACRPPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
 
             ENDDO
 
/* End program */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
