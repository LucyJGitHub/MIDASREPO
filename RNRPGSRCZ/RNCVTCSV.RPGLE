     h debug   alwnull(*usrctl)
     h fixnbr(*zoned : *inputpacked)
     h bnddir('QC2LE')
     h dftactgrp(*no) actgrp(*caller)
     h copyright('(c) Finastra International Limited 2005')
 
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas FRS Convert extract file to csv format')
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNCVTCSV   - Convert Extract File to CSV Format.             *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG10593           Date 15Feb06               *
      *                 CRN001  *CREATE    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG10593 - Program needs to handle special cases where       *
      *             numeric value is zero, but null is required.      *
      *             £Note that this program cannot read in nulls      *
      *             through its program-described input file.]        *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Notes:                                                       *
      *  - this program handles numeric fields of maximum length      *
      *    31, the limit at V5R2M0 (the current value in the          *
      *    standard creation parameter).                              *
      *  - the maximum number of decimal positions is the value       *
      *    specified on field wrkNumeric: 10 at the time the          *
      *    the program was created.                                   *
      *  - binary fields of 2 and 4-byte are handled.                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     frnextrct  if   f 9999        disk    infsr(*pssr)
     f                                     usropn
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     d pExtrFile       s             10
     d pExtrMember     s             10
 
     d inPssr          s               n
 
     d qCmdExc         pr                  extpgm('QCMDEXC')
     d                              256    const
     d                               15  5 const
 
     d cmdOvrdbf       ds
     d                         1     31    inz('OVRDBF FILE(+
     d                                          RNEXTRCT  ) TOFILE(')
     d  ovrToFile             32     41
     d                        42     47    inz(') MBR(')
     d  ovrToMbr              48     57
     d                        58     59    inz(')')
 
     d cmdDltovr       c                   'DLTOVR FILE(RNEXTRCT  )'
 
     d lenOvrdbf       c                   %len(cmdOvrdbf)
     d lenDltovr       c                   %len(cmdDltovr)
 
      /copy qsysinc/qrpglesrc,qusec
      /copy qsysinc/qrpglesrc,qusgen
      /copy qsysinc/qrpglesrc,quslfld
 
     d qualUsrSpcNm    s             20    inz('RNEXTSPC  QTEMP')
     d extAttr         s             10
     d initialSize     s              9B 0 inz(32768)
     d initialValue    s              1    inz(x'00')
     d publicAut       s             10    inz('*USE')
     d spcDesc         s             50    inz('Field List Space')
     d replace         s             10    inz('*YES')
 
     d qualFileName    ds
     d                               10    inz('RNEXTRCT')
     d                               10    inz('*LIBL')
 
     d libRetrnd       s             10
 
     d chgAttr         ds
     d  nbrAttr                       9b 0 inz(1)
     d  attrKey                       9b 0 inz(3)
     d  dataSize                      9b 0 inz(1)
     d  attrData                      1    inz('1')
 
     d spcPtr          s               *
     d fldInfo         s                   like(qusl0100)
     d                                     based(fldPtr)
 
     d startPos        s              9b 0 inz(0)
     d dataLen         s              9b 0 inz(0)
 
     d ix              s                   like(qusnbrle)
 
     d                 ds
     d aFldInfo                            dim(9999)
     d aFldNam                             like(qusfn02)                                    BUG10593
     d                                     overlay(aFldInfo : *next)                        BUG10593
     d aDtaTyp                             like(qusdt)
     d                                     overlay(aFldInfo : *next)
     d aOBfOff                             like(qusobp)
     d                                     overlay(aFldInfo : *next)
     d aBufLen                             like(qusflb)
     d                                     overlay(aFldInfo : *next)
     d aDecPos                             like(qusdp)
     d                                     overlay(aFldInfo : *next)
     d aColHg1                             like(qusch1)
     d                                     overlay(aFldInfo : *next)
     d aColHg2                             like(qusch2)
     d                                     overlay(aFldInfo : *next)
     d aColHg3                             like(qusch3)
     d                                     overlay(aFldInfo : *next)
 
     d binChar         ds
     d  bin2                          4b 0 overlay(binChar)
     d  bin4                          9b 0 overlay(binChar)
 
     d zonedChar       ds
     d  zoned                        31s10
 
     d packedChar      ds
     d  packed                       31p10
 
     d wrkNumeric      s             31 10
     d lenNumeric      c                   %len(wrkNumeric)
     d decposMax       c                   %decpos(wrkNumeric)
     d reqdLength      s              3u 0
     d trlChar         s              1
     d decposDiff      s                   like(qusdp)
     d nullReqd        s               n                                                    BUG10593
 
     d cComma          c                   ','
     d cDblQuote       c                   '"'
     d cDecPoint       c                   '.'
 
     d outRecord       s           2048    varying
     d outField        s           2048    varying
 
     d pValDs          ds
     d  pValK1                       20
     d  pVal1                       200
     d  pValK2                             like(pValK1)
     d  pVal2                              like(pVal1)
     d  pValK3                             like(pValK1)
     d  pVal3                              like(pVal1)
     d  pValK4                             like(pValK1)
     d  pVal4                              like(pVal1)
     d  pValK5                             like(pValK1)
     d  pVal5                              like(pVal1)
     d  pValK6                             like(pValK1)
     d  pVal6                              like(pVal1)
     d  pValK7                             like(pValK1)
     d  pVal7                              like(pVal1)
     d  pValK8                             like(pValK1)
     d  pVal8                              like(pVal1)
     d  pValK9                             like(pValK1)
     d  pVal9                              like(pVal1)
     d  pValK10                            like(pValK1)
     d  pVal10                             like(pVal1)
 
     d opened          s               n
     d msgid           s              7
     d pRtnCod         s              7
     d rcnum           s                   like(writeline)
 
     d fd              s             10i 0
     d len             s             10i 0
     d path            s            100
     d text            s           2048
 
      /copy rncpysrc,ifsio_h
      /copy rncpysrc,ifstext_h
      /copy rncpysrc,errno_h
 
     D DirName         S            200A
     D X               S              2  0
     D Y               S              2  0
     D DirArr1         S              1    DIM(200)
     D DirArr2         S              1    DIM(200)
     D Slash           C                   CONST('/')
     D RC              S             10I 0
      *=====================================================================
 
     irnextrct  ns
     i                                  1 9999  rnextfld
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declaratives                         ¦
      ** ¦ ============                         ¦
      ** +--------------------------------------+
 
     c     *entry        plist
     c                   parm                    pExtrFile
     c                   parm                    pExtrMember
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     c                   exsr      main
 
     c                   exsr      closedown
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  main   -  Main subroutine                                    *
      *                                                               *
      *****************************************************************
 
     c     main          begsr
 
     c                   exsr      getInpFlds
 
     c                   eval      opened      = *off
     c                   eval      path        = %trim(pVal1)
     c                                         + '/'
     c                                         + %trim(pExtrFile)
     c                                         + '.csv'
 
     c     *start        setll     rnextrct
     c                   read      rnextrct
     c                   dow       not %eof
 
     c                   if        not opened
     c                   eval      fd          = open(%trim(path)
     c                                           : O_CREAT
     c                                           + O_TRUNC
     c                                           + O_WRONLY
     c                                           : S_IRWXU + S_IRWXG + S_IRWXO)
 
     c                   if        fd          < 0
     c                   eval      msgid       = errno()
     c                   exsr      *pssr
     c                   endif
 
     c                   eval      opened      = *on
     c                   endif
 
     c                   exsr      procInpRec
 
     c                   eval      text        = outrecord
     c                   eval      len         = %len(%trimr(text))
     c                   eval      rcnum       = writeline(fd
     c                                                    :%addr(text)
     c                                                    :len )
 
     c                   if        rcnum       = -1
     c                   eval      msgid       = errno()
     c                   callp     close(fd)
     c                   exsr      *pssr
     c                   endif
 
     c                   read      rnextrct
     c                   enddo
 
     c                   callp     close(fd)
 
     c                   endsr
      *********************************************************************
      *                                                                   *
      * getInpFlds - Subroutine that retrieves input fields               *
      *                                                                   *
      *********************************************************************
 
     c     getInpFlds    begsr
 
      * Set bytes provided (used in error code parameter).
     c                   eval      qusbprv     = 16
 
      * Create user space.
     c                   call      'QUSCRTUS'
     c                   parm                    qualUsrSpcNm
     c                   parm      pExtrFile     extAttr
     c                   parm                    initialSize
     c                   parm                    initialValue
     c                   parm                    publicAut
     c                   parm                    spcDesc
     c                   parm                    replace
     c                   parm                    qusec
 
     c                   exsr      chkApiErr
 
      *---------------------------------------------------------------------
 
      * Change user space to be extendable.
     c                   call      'QUSCUSAT'
     c                   parm                    libRetrnd
     c                   parm                    qualUsrSpcNm
     c                   parm                    chgAttr
     c                   parm                    qusec
 
     c                   exsr      chkApiErr
 
      *---------------------------------------------------------------------
 
      * Retrieve pointer to user space.
     c                   call      'QUSPTRUS'
     c                   parm                    qualUsrSpcNm
     c                   parm                    spcPtr
     c                   parm                    qusec
 
     c                   exsr      chkApiErr
 
      *---------------------------------------------------------------------
 
     c                   call      'QUSLFLD'
     c                   parm                    qualUsrSpcNm
     c                   parm      'FLDL0100'    fmtName           8
     c                   parm                    qualFileName
     c                   parm      '*FIRST'      rec_fmt          10
     c                   parm      '1'           override          1
     c                   parm                    qusec
 
     c                   exsr      chkApiErr
 
      *---------------------------------------------------------------------
 
     c                   eval      startPos    = 1
     c                   eval      dataLen     = %len(qush0100)
     c                   call      'QUSRTVUS'
     c                   parm                    qualUsrSpcNm
     c                   parm                    startPos
     c                   parm                    dataLen
     c                   parm                    qush0100
 
     c                   exsr      chkApiErr
 
      *---------------------------------------------------------------------
 
     c                   clear                   aFldInfo
     c                   eval      fldPtr      = spcPtr
     c                                         + qusold
 
     c                   for       ix          = 1 to qusnbrle
     c                   eval      qusl0100    = fldInfo
 
     c                   eval      aFldNam(ix) = qusfn02                                    BUG10593
     c                   eval      aDtaTyp(ix) = qusdt
     c                   eval      aOBfOff(ix) = qusobp
     c                   eval      aBufLen(ix) = qusflb
     c                   eval      aDecPos(ix) = qusdp
     c                   eval      aColHg1(ix) = qusch1
     c                   eval      aColHg2(ix) = qusch2
     c                   eval      aColHg3(ix) = qusch3
 
      * Adjust for variable length field.
     c                   if        qusvlfi     = '1'
     c                   eval      aOBfOff(ix) = aOBfOff(ix)
     c                                         + 2
     c                   eval      aBufLen(ix) = aBufLen(ix)
     c                                         - 2
     c                   endif
 
     c                   if        ix          < qusnbrle
     c                   eval      fldPtr      = fldPtr
     c                                         + qussee
     c                   endif
 
     c                   endfor
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * procInpRec - Subroutine that processes input records              *
      *                                                                   *
      *********************************************************************
 
     c     procInpRec    begsr
 
     c                   clear                   outRecord
 
     c                   for       ix          = 1 to qusnbrle
 
     c                   select
     c                   when      aDtaTyp(ix) = 'A'
     c                   exsr      chkCharData
 
     c                   when      aDtaTyp(ix) = 'B'
     c                   exsr      chkBinary
 
     c                   when      aDtaTyp(ix) = 'P'
     c                   exsr      chkPacked
 
     c                   when      aDtaTyp(ix) = 'S'
     c                   exsr      chkZoned
 
      * Unexpected type: treat as character.
     c                   other
     c                   exsr      chkCharData
     c                   endsl
     c                   endfor
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * chkCharData - Subroutine that checks for character data           *
      *                                                                   *
      *********************************************************************
 
     c     chkCharData   begsr
 
     c                   eval      outField    = %trimr(%subst(rnextfld
     c                                                       : aOBfOff(ix)
     c                                                       : aBufLen(ix)))
 
     c                   if        (   aDtaTyp(ix) = 'A'
     c                             and %scan(cComma : outField) > 0 )
     c                   eval      outField    = cDblQuote
     c                                         + outField
     c                                         + cDblQuote
     c                   endif
 
     c                   exsr      addString
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * chkBinary - Subroutine that checks for binary data                *
      *                                                                   *
      *********************************************************************
 
     c     chkBinary     begsr
 
     c                   eval      binChar     = %subst(rnextfld
     c                                                : aOBfOff(ix)
     c                                                : aBufLen(ix) )
     c                   select
     c                   when      aBufLen(ix) = 2
     c                   eval      wrkNumeric  = bin2
     c                   exsr      fmtNumeric
 
     c                   when      aBufLen(ix) = 4
     c                   eval      wrkNumeric  = bin4
     c                   exsr      fmtNumeric
 
     c                   other
     c                   exsr      *pssr
     c                   endsl
 
     c                   exsr      addString
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * chkPacked - Subroutine that checks for packed decimal data        *
      *                                                                   *
      *********************************************************************
 
     c     chkPacked     begsr
 
     c                   eval      packed      = 0
 
     c                   eval      %subst(packedChar
     c                                  : %len(packedChar) - aBufLen(ix) + 1
     c                                  : aBufLen(ix) )
     c                                         = %subst(rnextfld
     c                                                : aOBfOff(ix)
     c                                                : aBufLen(ix) )
 
     c                   eval      wrkNumeric  = packed
     c                   exsr      fmtNumeric
 
     c                   exsr      addString
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * chkZoned - Subroutine that checks for zoned decimal data          *
      *                                                                   *
      *********************************************************************
 
     c     chkZoned      begsr
 
     c                   eval      zoned       = 0
 
     c                   eval      %subst(zonedChar
     c                                  : %len(zonedChar) - aBufLen(ix) + 1
     c                                  : aBufLen(ix) )
     c                                         = %subst(rnextfld
     c                                                : aOBfOff(ix)
     c                                                : aBufLen(ix) )
 
     c                   eval      wrkNumeric  = zoned
     c                   exsr      fmtNumeric
 
     c                   exsr      addString
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * fmtNumeric - Subroutine that formats numeric data                 *
      *                                                                   *
      *********************************************************************
 
     c     fmtNumeric    begsr
 
      * This s/r formats the numeric field into character data,
      * discarding unnecessary leading/trailing characters.
                                                                                            BUG10593
     c                   exsr      chkSpcCases                                              BUG10593
 
     c                   select
     c                   when      nullReqd                                                 BUG10593
     c                   eval      %len(outField) = 0                                       BUG10593
 
     c                   when      wrkNumeric  = 0
     c                   eval      outField    = %char(0)
 
     c                   when      aDecPos(ix) > decposMax
     c                   eval      outField    = %char(
     c                                            wrkNumeric
     c                                            / (10 **
     c                                            (aDecPos(ix)-decposMax)))
 
     c                   other
 
      * Note: repeated multiplication preferred to exponentiation so
      * that loss of significance with fp arithmetic is avoided.
     c                   eval      decposDiff  = decposMax
     c                                         - aDecPos(ix)
     c                   do        decposDiff
     c                   eval(r)   wrkNumeric *= 10
     c                   enddo
 
     c                   eval      outField    = %char(wrkNumeric)
 
     c                   eval      reqdLength  = %len(outField)
     c                                         + aDecPos(ix)
     c                                         - decposMax
 
     c                   if        aDecPos(ix) = 0
     c                   eval      reqdLength  = reqdLength
     c                                         - 1
     c                   endif
 
     c                   eval      outField    = %subst(outField
     c                                                : 1
     c                                                : reqdLength )
 
      * Remove trailing zeroes / trailing decimal point.
     c                   eval      trlChar     = %subst(outField
     c                                                : %len(outField)
     c                                                : 1)
     c                   dow       %scan(cDecPoint : outField) > 0
     c                             and (   trlChar = *zero
     c                                 or  trlChar = cDecPoint )
     c                   eval      outField    = %subst(outField
     c                                                : 1
     c                                                : %len(outField)-1)
 
     c                   eval      trlChar     = %subst(outField
     c                                                : %len(outField)
     c                                                : 1)
     c                   enddo
 
     c                   endsl
 
     c                   endsr
                                                                                            BUG10593
      *********************************************************************                 BUG10593
      /EJECT                                                                                BUG10593
      *********************************************************************                 BUG10593
      *                                                                   *                 BUG10593
      * Subroutine to check special cases                                 *                 BUG10593
      *   e.g. Numeric value set to zero where null is required.          *                 BUG10593
      *                                                                   *                 BUG10593
      *********************************************************************                 BUG10593
                                                                                            BUG10593
     c     chkSpcCases   begsr                                                              BUG10593
                                                                                            BUG10593
     c                   eval      nullReqd                                                 BUG10593
     c                             =   (    pExtrFile   = 'T__MOVLEG'                       BUG10593
     c                                 and  aFldNam(ix) = 'TRANSACT'                        BUG10593
     c                                 and  wrkNumeric  = 0           )                     BUG10593
                                                                                            BUG10593
     c                   endsr                                                              BUG10593
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * addString - Subroutine that builds outrecord string               *
      *                                                                   *
      *********************************************************************
 
     c     addString     begsr
 
     c                   if        ix          > 1
     c                   eval      outRecord   = outRecord
     c                                         + cComma
     c                   endif
     c                   eval      outRecord   = outRecord
     c                                         + outField
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * chkApiErr - Subroutine that checks for API errors                 *
      *                                                                   *
      *********************************************************************
 
     c     chkApiErr     begsr
 
     c                   if        qusbavl     > 0
     c                   exsr      *pssr
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  closedown -  Return to Calling Program                       *
      *                                                               *
      *****************************************************************
 
     c     closedown     begsr
 
      * Close and delete override.
     c                   if        %open(rnextrct)
     c                   close     rnextrct
     c                   endif
 
     c                   callp(e)  qCmdExc(cmdDltovr : lenDltovr)
 
     c                   eval      *inlr       = *on
     c                   return
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      *****************************************************************
 
     c     *inzsr        begsr
 
      * Override to file & member (if passed) parameters.
     c                   eval      ovrToFile   = pExtrFile
     c                   if        %parms      > 1
     c                   eval      ovrToMbr    = pExtrMember
     c                   endif
 
     c                   callp     qCmdExc(cmdOvrdbf : lenOvrdbf)
 
     c                   open      rnextrct
 
      * Retrieve Midas AO system value
     c                   eval      pValDs      = *blank
     c                   eval      pValK1      = 'FRSExportDirectory'
 
     c                   call      'AOSVALR0'
     c                   parm      '*DBERR'      pRtnCod
     c                   parm                    pValK1
     c                   parm                    pVal1
     c                   parm                    pValK2
     c                   parm                    pVal2
     c                   parm                    pValK3
     c                   parm                    pVal3
     c                   parm                    pValK4
     c                   parm                    pVal4
     c                   parm                    pValK5
     c                   parm                    pVal5
     c                   parm                    pValK6
     c                   parm                    pVal6
     c                   parm                    pValK7
     c                   parm                    pVal7
     c                   parm                    pValK8
     c                   parm                    pVal8
     c                   parm                    pValK9
     c                   parm                    pVal9
     c                   parm                    pValK10
     c                   parm                    pVal10
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     c     *pssr         begsr
 
     c                   if        not inPssr
     c                   eval      inPssr      = *on
     c                   eval      *inu7       = *on
     c                   eval      *inu8       = *on
     c                   dump
     c                   exsr      closedown
 
     c                   else
     c                   eval      *inlr       = *on
     c                   return
     c                   endif
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * writeline procedure - writes record lines to IFS                  *
      *                                                                   *
      *********************************************************************
 
     p writeline       b
     d                 pi            10i 0
 
     d fd                            10i 0 value
     d text                            *   value
     d len                           10i 0 value
 
     d rc1             s             10i 0
     d rc2             s             10i 0
     d eol             s              2
 
      * write the text provided
     c                   if        len         > 0
     c                   eval      rc1         = write(fd: text: len)
 
     c                   if        rc1         < 1
     c                   return    rc1
     c                   endif
     c                   endif
 
      * then add the end-of-line chars
     c                   eval      eol         = x'0d25'
     c                   eval      rc2         = write(fd: %addr(eol): 2)
 
     c                   if        rc2         < 1
     c                   return    rc2
     c                   endif
 
     c                   return    rc1 + rc2
 
     p                 e
 
      *=====================================================================
 
      /define ERRNO_LOAD_PROCEDURE
      /copy rncpysrc,errno_h
