/*********************************************************************/
/*STD    CMDBASEPGM                                                  */
/*EXI    PGM(SDC1778C)   VLDCKR(*NONE)      MSGF(QCPFMSG)            */
/*EXI *  TEXT('Midas SC Check valid CPF name')                       */
/*********************************************************************/
/*                                                                   */
/*  Midas - System Control Module                                    */
/*                                                                   */
/*  SCCHKCPF - CHECK VALID CPF NAME                                  */
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
/*       Prev Amend No. S01343             Date 15Aug91              */
/*                      E13205             Date 03Apr89              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01343 - SC/RR/SD MODULE RENAME PROJECT.                    */
/*                - SCCHKCPF RENAMED FROM SDC1778B                   */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Verify Value name')
             PARM       KWD(IN) TYPE(*NAME) PROMPT('Cpf name')
             PARM       KWD(OUT) TYPE(*CHAR) LEN(10) RTNVAL(*YES) +
                          PROMPT('Return name')
