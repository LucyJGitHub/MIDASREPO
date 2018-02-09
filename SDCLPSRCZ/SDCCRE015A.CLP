/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE T&N Accounts - Feature Initialisation')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail T&N Accounts                                 */
/*                                                                   */
/*       CLP/SDCCRE015A - Feature Initialisation                     */
/*                                                                   */
/*       (c) Finastra International Limited 2009                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CRE015  *CREATE    Date 18Dec09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE015 - Retail Term and Notice Accounts                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CLEAR)
 
             DCL        VAR(&CLEAR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CHARGEAC) TYPE(*CHAR) LEN(6)
 
/* Only re-initialise and clear file if user takes clear *yes option */
/* else go to end                                          */
 
             IF         COND(&CLEAR = '*YES') THEN(DO)
 
/* Global Values */
 
             CHGVAR     VAR(&CHARGEAC) VALUE('''' *CAT '0000' *CAT +
                          '''')
 
             ENDJRNPF   FILE(SDACD1PD)
             MONMSG CPF0000
             ENDJRNPF   FILE(RENFMVPD)
             MONMSG CPF0000
             ENDJRNPF   FILE(RERTMVPD)
             MONMSG CPF0000
             ENDJRNPF   FILE(RERTMUPD)
             MONMSG CPF0000
             ENDJRNPF   FILE(REPRPNPD)
             MONMSG CPF0000
             CLRPFM     FILE(SDACD1PD)
             CLRPFM     FILE(RENFMVPD)
             CLRPFM     FILE(RERTMVPD)
             CLRPFM     FILE(RERTMUPD)
             CLRPFM     FILE(REPRPNPD)
 
             STRJRNPF   FILE(SDACD1PD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(RENFMVPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(RERTMVPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(RERTMUPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
             STRJRNPF   FILE(REPRPNPD) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000)
 
             DLTF       FILE(QTEMP/A5ACCD)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/A5ACCD) RCDLEN(10)
             OPNQRYF    FILE((SDACD1PD)) FORMAT(QTEMP/A5ACCD) +
                          IGNDECERR(*YES)
             CPYFRMQRYF FROMOPNID(SDACD1PD) TOFILE(QTEMP/A5ACCD) +
                          MBROPT(*ADD)
             CLOF       OPNID(SDACD1PD)
             OPNQRYF    FILE((SDACODPD)) FORMAT(QTEMP/A5ACCD) +
                          IGNDECERR(*YES)
             CPYFRMQRYF FROMOPNID(SDACODPD) TOFILE(QTEMP/A5ACCD) +
                          MBROPT(*ADD)
             CLOF       OPNID(SDACODPD)
             OPNQRYF    FILE((QTEMP/A5ACCD)) FORMAT(SDACD1PD) +
                          MAPFLD((A5ATTY '''O''') (A5CHIA +
                          &CHARGEAC) (A5RTTY ''' ''') (A5NVCD ''' +
                          ''') (A5PRFC ''' ''') (A5RTDN -1) (A5RTDI +
                          -1)) IGNDECERR(*YES)
             CPYFRMQRYF FROMOPNID(A5ACCD) TOFILE(SDACD1PD) MBROPT(*ADD)
             CLOF       OPNID(A5ACCD)
             DLTF       FILE(QTEMP/A5ACCD)
 
             ENDDO
 
             ENDPGM
