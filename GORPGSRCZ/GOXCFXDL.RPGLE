     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*OVR *  OVRDBF FILE(DEALSX) TOFILE(DEALS) SHARE(*NO)                 *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract Controller for FX Deals')             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXCFXDL - Controller for Foreign                            *
      *             Exchange Deals                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 01Sep14               *
      *                 AR644662           Date 19Aug14               *
      *                 AR582204           Date 11Apr12               *
      *                 CSW212             Date 03May12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG13562           Date 16Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR644662 - Exclude deals that matured and expired during the *
      *             holidays.  (Child: AR644663)                      *
      *  AR582204 - Exclude deleted deals. Applied fix 258723.        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG13562 - Do not extract matured transactions into GPTRAPPD *
      *   Fix was also applied to MP121 via 246296 bug                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FFXDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(FXDEALP0)
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(DEALSDBF)
     FDEALSX    IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(DEALSDBF)
     F                                     RENAME(DEALSDBF:DEALSDBFX)
     F                                     PREFIX(OL_)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D FXDEAL        E DS                  EXTNAME(FXDEALPP)
     D DEALDB        E DS                  EXTNAME(DEALSDB)
 
 
     C     *ENTRY        PLIST
      /COPY GOCPYSRC,GOXCEPARM
      *
      * EXTRACT ALL FX DEALS
      * OR EXTRACT A SINGLE FX DEAL
      *
     C     I#EXTT        IFEQ      '*ALL'
     C                   EXSR      EXTALL
     C                   SETON                                        LR
     C                   ELSE
     C                   EXSR      EXTSIN
     C                   ENDIF
      *
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * EXTRACT ALL FX DEALS
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      FXDEALP0                               99    *
      *
      * Whilst deals can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      **Extract*any*live*or*matured*FX*deals*                                               BUG13562
      * Extract any live FX deals                                                           BUG13562
      *
     C     FHDDLT        IFEQ      *BLANK                                                   AR582204
     C     FHDSTS        IFEQ      'C'
     C     FHDSTS        OREQ      'A'
     C     FHDSTS        OREQ      'R'
     C*****FHDSTS        OREQ      'M'                                                      BUG13562
     C                   EXSR      ACS_OTHER_DTLS
     C     RECI          IFNE      'M'                                                      AR644662
     C     RECI          ANDNE     'E'                                                      AR644662
     C                   MOVEL     'V'           Trade_Value       1
     C                   EXSR      EXTRCT
     C                   MOVEL     'T'           Trade_Value
     C                   EXSR      EXTRCT
     C                   ENDIF                                                              AR644662
     C                   ENDIF
     C                   ENDIF                                                              AR582204
      *
      * Read the next record
      *
     C                   READ      FXDEALP0                               99    *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE FX DEAL
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C                   MOVEL     I#TREF        W#DLNO            6 0
     C     W#DLNO        CHAIN     FXDEALP0                           99        *
      *
      * If the deal is found
      * access other details
      * extract it
      * if not matured                                                                      BUG13562
      *
     C     *IN99         IFEQ      '0'
     C     FHDSTS        ANDNE     'M'                                                      BUG13562
     C     FHDDLT        ANDEQ     *BLANK                                                   AR582204
     C                   EXSR      ACS_OTHER_DTLS
     C     RECI          IFNE      'M'                                                      AR644662
     C     RECI          ANDNE     'E'                                                      AR644662
     C                   MOVEL     'V'           Trade_Value       1
     C                   EXSR      EXTRCT
     C                   MOVEL     'T'           Trade_Value
     C                   EXSR      EXTRCT
     C                   ENDIF                                                              AR644662
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT
      ********************************************************************
     C     EXTRCT        BEGSR
      *
     C                   CALLB     'GOXTFXDL'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM      I#LOC         W#LOC             4
     C                   PARM      I#CCID        W#CCID           10 0
 
     C                   PARM      I#RDNB        W#RDNB            5 0
     C                   PARM      I#DNWD        W#DNWD            5 0
     C                   PARM      I#PCOD        W#PCOD            5 0
     C                   PARM      Trade_Value   W#TVDI            1
     C                   PARM                    FXDEAL
     C                   PARM                    DEALDB
     C                   PARM                    OL_ACEI
 
      * If data error encountered, log error
 
     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = 'FXDL' + I#EXTT + I#TREF
     C                             + W#RTCD + W#ERMS + FXDEAL
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Access other details
      ********************************************************************
     C     ACS_OTHER_DTLSBEGSR
      *
      * Get further deal details needed from DEALSDB
      *
     C                   CLEAR                   DEALDB
     C     FHDN38        CHAIN     DEALSDBF                           99        *
 
      * Get 1st leg of swap
 
     C     FSLI          IFEQ      2
     C     SODN          CHAIN     DEALSDBFX                          99
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Get Extract control information
 
      /COPY GOCPYSRC,GOGETEXCT
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
