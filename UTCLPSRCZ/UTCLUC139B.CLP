/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('LUC139 file set up utility')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas SD - Standing Data Module                             */
/*                                                                   */
/*       UTCLUC139B - Midas UT Italian returns utility               */
/*                                                                   */
/*       (c) Finastra International Systems Ltd. 2021                */
/*                                                                   */
/*       Last Amend No. MD058100           Date 20May21              */
/*       Prev Amend No. LUC139   *Amend    Date 02Mar21              */
/*                      LUC139   *Create   Date 20Jan21              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     MD058100 - Rollup of additional BoI onsite fixes at FbMidas   */
/*     LUC139 - UCI Italian returns Upgrade to FM2.1                 */
/*                                                                   */
/*********************************************************************/
             PGM
             clrpfm ACCNTBXP
             clrpfm ERGUEXPD
             clrpfm ERGUARPD
             clrpfm IRDPSTPD
             clrpfm IRMPSTPD
             clrpfm IRPMPCPD
             RMVPFTRG FILE(SDCUAHPD  )
             MONMSG     MSGID(CPF32C6)
             clrpfm SDCUAHPD
             CPYF       FROMFILE(MLDMLIB/ACCNTBXP) +
                          TOFILE(IACCNTBXP) MBROPT(*REPLACE)
             CPYF       FROMFILE(MLDMLIB/IRDPSTPD) +
                          TOFILE(iIRDPSTPD) MBROPT(*REPLACE)
             CPYF       FROMFILE(MLDMLIB/IRMPSTPD) +
                          TOFILE(iIRMPSTPD) MBROPT(*REPLACE)
             CPYF       FROMFILE(MLDMLIB/IRPMPCPD) +
                          TOFILE(iIRPMPCPD) MBROPT(*REPLACE)  fmtopt(*nochk)
             CPYF FROMFILE(ERICDRPD) TOFILE(ERICDXPD) MBROPT(*REPLACE)
             CPYF FROMFILE(ERBankPD) TOFILE(ERBNKXPD) MBROPT(*REPLACE)
             CPYF FROMFILE(EROUTFPD) TOFILE(EROUTXPD) MBROPT(*REPLACE)
             CPYF FROMFILE(ERLUICPD) TOFILE(ERLICXPD) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2869 CPF2817)
             CPYF FROMFILE(ERDEALPD) TOFILE(ERDEAXPD) MBROPT(*REPLACE)
             ENDPGM
