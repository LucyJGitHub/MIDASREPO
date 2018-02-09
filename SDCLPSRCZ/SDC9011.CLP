/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Update MODUPDATE data area')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Standing Data Module                            */
/*                                                                   */
/*       SDC9011 - Update MODUPDATE Data Area.                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BG12355A           Date 29Oct06              */
/*                      BUG12355           Date 27Oct06              */
/*                      CPK024             Date 12Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAAA01             DATE 22Feb95              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG12355A - Reverse BUG12355 fix                             */
/*       BUG12355 - Retail Number does not show in Account Mainty    */
/*                  screen input                                     */
/*       CPK024 - Packaging of MPlus 1.2.1. Copy sources needed by   */
/*                UTC0012.                                           */
/*       CAAA01 - GUI/400 Development.                               */
/*                - Created for this development.                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&VALUE)
 
/***COPY*SDCPYSRC,SDC9011INT*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC9011INT                                          */                   /*CPK024*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&VALUE) TYPE(*CHAR) LEN(1)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/***COPY*SDCPYSRC,SDC9011MPS*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC9011MPS                                          */                   /*CPK024*/
 
             CHGDTAARA  DTAARA(MODUPDATE (1 1)) VALUE(&VALUE)
                                                                           /*BUG12355*/ /*BG12355A*/
             CALL       PGM(APCCRTNDFL)                                    /*BUG12355*/ /*BG12355A*/
 
/***COPY*SDCPYSRC,SDC9011MPE*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC9011MPE                                          */                   /*CPK024*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/***COPY*SDCPYSRC,SDC9011ERR*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC9011ERR                                          */                   /*CPK024*/
 
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/***COPY*SDCPYSRC,SDC9011END*                                        */                   /*CPK024*/
/*/COPY WNCPYSRC,SDC9011END                                          */                   /*CPK024*/
 
             ENDPGM
