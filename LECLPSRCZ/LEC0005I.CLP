/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Init new flds of amended LE files (T3)')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Upgrade Utility                                     */
/*                                                                   */
/*       LEC0005I - LE Initialisation Program                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 134802             Date 02Oct98              */
/*       Prev Amend No. CLE005 *Create     Date 22May97              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       134802  - New program to drop all outstanding repayments    */
/*       CLE005  - Customer Lending Enhancements - Tranche 3         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RETCD &MODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RETCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             IF         COND(&MODE *NE '3') THEN(CALL PGM(LE0006))
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)              /*134802*/
             IF         COND(&MODE *NE '3') THEN(CALL PGM(LE0454))    /*134802*/
             ENDDO                                                    /*134802*/
                                                                      /*134802*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))
 
             ELSE       CMD(DO)
               CHGVAR     VAR(&RETCD) VALUE('*ERROR*')
               CHGJOB     SWS(XXXXXX00)
             ENDDO
 
 ABNOR:      SNDPGMMSG  MSG('Program LEC0005I ended abnormally')   +
                          TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
