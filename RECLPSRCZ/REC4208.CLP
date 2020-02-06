/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Remove file members from teller')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4208 - Remove File Members from Teller Transaction       */
/*                 File                                              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG2488            Date 31May04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CRT001  *CREATE    Date 28Feb95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                         */
/*       BUG2488- Logical file REDDSSRCDV/TTRANL6 is based over  a   */
/*                phsical which is set to members = *nomax.  Amend   */
/*                TTRANL6 and create a  new logical file TTRANL7.    */
/*       CRT001 - Retail Teller System                               */
/*                                                                   */
/*********************************************************************/
             PGM       PARM(&TBRI &TLID &RETCD)
 
/*/COPY WNCPYSRC,REC4208INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEMBR)  TYPE(*CHAR)  LEN(4)
             DCL        VAR(&TBRI)   TYPE(*CHAR)  LEN(1)
             DCL        VAR(&TLID)   TYPE(*CHAR)  LEN(3)
             DCL        VAR(&RETCD)  TYPE(*CHAR)  LEN(2)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
 
/* Send program message */
 
             SNDPGMMSG  MSG('REC4208 - Retail Teller System Remove +
                             File Members') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/*/COPY WNCPYSRC,REC4208MPS                                          */
 
/* If teller - ID is not blanks */
 
             IF         COND(&TLID *NE BLANKS) THEN(DO)
 
/* Set variable &MEMBR as &TBRI + the teller - ID passed */
 
/**********     CHGVAR     VAR(&MEMBR) VALUE(&TBRI****&TLID)                          */ /*BG18886*/
                CHGVAR     VAR(&MEMBR) VALUE(&TBRI *CAT &TLID)                           /*BG18886*/
 
/* Remove logical file member &MEMBR from TTRANL1 */
 
                RMVM       FILE(TTRANL1) MBR(&MEMBR)
                MONMSG     MSGID(CPF0000)
 
/* Remove logical file member &MEMBR from TTRANL2 */
 
                RMVM       FILE(TTRANL2) MBR(&MEMBR)
                MONMSG     MSGID(CPF0000)
 
/* Remove logical file member &MEMBR from TTRANL7 */                                     /*BUG2488*/
                                                                                         /*BUG2488*/
                RMVM       FILE(TTRANL7) MBR(&MEMBR)                                     /*BUG2488*/
                MONMSG     MSGID(CPF0000)                                                /*BUG2488*/
                                                                                         /*BUG2488*/
/* Remove member &MEMBR from physical files TTRANPD & TTRANPT */
 
                RMVM       FILE(TTRANPD) MBR(&MEMBR)
                MONMSG     MSGID(CPF0000)
 
                RMVM       FILE(TTRANPT) MBR(&MEMBR)
                MONMSG     MSGID(CPF0000)
 
                GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* Abnormal termination */
ABNORMAL:
/*/COPY WNCPYSRC,REC4208ERR                                          */
 
/* Set return code parameter &RETCD to '01' */
 
             CHGVAR     VAR(&RETCD) VALUE('01')
 
 ENDPGM:
 
/*/COPY WNCPYSRC,REC4208END                                          */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
