/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL OIS Deals Bulk Rate Correction Control')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC1666 - OIS Deals Bulk Rate Correction Control            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 238193             Date 18Aug06              */
/*                      226723             Date 12May04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CIR007 *Create     Date 11May01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       238193 - Allow the entry of negative base rates for OIS.    */
/*                Applied 226723.                                    */
/*       226723 - Allow the entry of negative base rates for OIS     */
/*                Partially applied 219286.                          */
/*       CIR007 - Overnight Index Swaps                              */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&PSEQ &PLEV &PENT &PARMS)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&WID)  TYPE(*CHAR)  LEN(10)
             DCL        VAR(&SWS)  TYPE(*CHAR)  LEN(8)
             DCL        VAR(&MSG)  TYPE(*CHAR)  LEN(50)
 
             DCL        VAR(&PSEQ) TYPE(*CHAR)  LEN(5)
             DCL        VAR(&PLEV) TYPE(*CHAR)  LEN(1)
             DCL        VAR(&PENT) TYPE(*CHAR)  LEN(3)
 
             DCL        VAR(&PARMS)  TYPE(*CHAR)  LEN(100)
             DCL        VAR(&WBRTC) TYPE(*CHAR)  LEN(3)
             DCL        VAR(&WBRTD) TYPE(*CHAR)  LEN(6)
             DCL        VAR(&WBRCO) TYPE(*CHAR)  LEN(2)
             DCL        VAR(&WNBRT) TYPE(*CHAR)  LEN(10)
             DCL        VAR(&WSIGN) TYPE(*CHAR)  LEN(1)                                   /*226723*/
 
             MONMSG     MSGID(CPA0000 MCH0000 RPG0000 CPF0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/** Derive Required Base Rate Currency Code                        */
 
             CHGVAR     VAR(&WBRTC) VALUE(%SST(&PARMS 1 3))
 
/** Derive Required Base Rate Date                                 */
 
             CHGVAR     VAR(&WBRTD) VALUE(%SST(&PARMS 4 9))
 
/** Derive Required Base Rate Code                                 */
 
             CHGVAR     VAR(&WBRCO) VALUE(%SST(&PARMS 10 11))
 
/** Derive Required New Base Rate                                  */
 
             CHGVAR &WNBRT VALUE(%SST(&PARMS 12 21))
                                                                                          /*226723*/
/** Derive the sign of the new base rate                             */                   /*226723*/
                                                                                          /*226723*/
             CHGVAR &WSIGN VALUE(%SST(&PARMS 22 22))                                      /*226723*/
                                                                                          /*226723*/
 
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)
 
/** Call the OIS Deal Bulk Rate Correction program to update the   */
/** OIS Compounding Interest Rate File and generate a Correction   */
/** Report.                                                        */
 
/**********  CALL       PGM(DL1666) PARM(&PSEQ &PLEV &PENT &WBRTC +  */                   /*226723*/
/**********               &WBRTD &WBRCO &WNBRT)                      */                   /*226723*/
             CALL       PGM(DL1666) PARM(&PSEQ &PLEV &PENT &WBRTC +
                          &WBRTD &WBRCO &WNBRT &WSIGN)                                    /*226723*/
 
             RTVJOBA    JOB(&WID) SWS(&SWS)
 
             IF COND(%SWITCH(XXXXXX00)) +
             THEN(DO)
                GOTO CMDLBL(END)
             ENDDO
 
             IF COND(%SWITCH(XXXXXX1X) *OR +
                     %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('OIS Deal Bulk Rate +
                          Correction program DL1666 has ended +
                          abnormally.')
                GOTO   CMDLBL(ABNOR)
             ENDDO
 
 ABNOR:      SNDPGMMSG  MSG('OIS Deals Bulk Rate Correction ended +
                          Abnormally') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:        ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
