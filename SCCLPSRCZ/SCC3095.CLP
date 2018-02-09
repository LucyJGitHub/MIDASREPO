/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Journal files when a feature if set on')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC3095 - Journal Files When a Feature is Set On            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      139358  *CREATE    Date 22Jul98              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       139358 - New program created to automatically journal       */
/*                files when a switchable feature is set on.         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FEATURE)
 
/*/COPY WNCPYSRC,SCC3095INT                                          */
 
             DCL        VAR(&FEATURE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FOUND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCLF       FILE(SCSAROL1)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)
 
/**********  IF         COND(&MPHAS *NE 'A') THEN(GOTO CMDLBL(END))                    */ /*CCB020*/
             IF         COND((&MPHAS *NE 'A') *AND (MPHAS *NE 'G')) +
                          THEN(GOTO CMDLBL(END))                                          /*CCB020*/
 
/*/COPY WNCPYSRC,SCC3095MPS                                          */
 
 RCVF:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
             IF         COND((&AFSARN *EQ &FEATURE) *AND (&AFOBAT +
                          *EQ 'PF')) THEN(DO)
                CHGVAR     VAR(&FOUND) VALUE(Y)
                STRJRNPF   FILE(&AFOBNM) JRN(ICJRN) IMAGES(*BOTH) +
                             OMTJRNE(*OPNCLO)
                MONMSG     MSGID(CPF7030)
             ENDDO
 
             IF         COND((&FOUND *EQ 'Y') *AND (&FEATURE *NE +
                          &AFSARN)) THEN(GOTO CMDLBL(END))
 
             GOTO       CMDLBL(RCVF)
 
/*/COPY WNCPYSRC,SCC3095MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Abnormal termination */
 
/*/COPY WNCPYSRC,SCC3095ERR                                          */
 
             SNDPGMMSG  MSG('Program SCC3095 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,SCC3095END                                          */
 
             ENDPGM
