     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract controller for NAs purchased')        *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXCNASP - Extract Controller for Money Market               *
      *             Negotiable Assets Purchased                       *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 AR644662           Date 19Aug14               *
      *                 AR582204           Date 11Apr12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG13562           Date 16Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR644662 - Exclude deals that matured during the holidays.   *
      *             (Child: AR644663)                                 *
      *  AR582204 - Exclude deleted deals. Applied fix 258723.        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG13562 - Do not extract matured transactions into GPTRAPPD *
      *     Fix was also applied to MP121 via 246296 bug              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************

     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(MMDENBP0)
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(DEALSDDF)


     D/COPY ZACPYSRC,STD_D_SPEC


     D MMDENB        E DS                  EXTNAME(MMDENBPP)
     D DEALDD        E DS                  EXTNAME(DEALSDD)
     D  DEALRONS     E                     EXTFLD(RONSQQ)                                     CGL029
     D  DEALPONS     E                     EXTFLD(PONSQQ)                                     CGL029


     C     *ENTRY        PLIST
      /COPY GOCPYSRC,GOXCEPARM
      *
      * EXTRACT ALL NA'S PURCHASED
      * OR EXTRACT A SINGLE NA PURCHASED
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
      * EXTRACT ALL NA'S PURCHASED
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      MMDENBP0                               99    *
      *
      * Whilst deals can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      **Extract*any*live*or*matured*NA's*purchased*                                         BUG13562
      * Extract any live NA's purchased                                                     BUG13562
      *
     C     HLDDLT        IFEQ      *BLANK                                                   AR582204
     C     HLDSTS        IFEQ      'C'
     C     HLDSTS        OREQ      'A'
     C     HLDSTS        OREQ      'R'
     C*****HLDSTS        OREQ      'M'                                                      BUG13562
     C                   EXSR      ACS_OTHER_DTLS
     C     RECI          IFNE      'M'                                                      AR644662
     C                   MOVEL     'V'           Trade_Value       1
     C                   EXSR      EXTRCT
     C                   MOVEL     'T'           Trade_Value
     C                   EXSR      EXTRCT
     C                   ENDIF                                                              AR644662
     C                   END
     C                   ENDIF                                                              AR582204
      *
      * Read the next record
      *
     C                   READ      MMDENBP0                               99    *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE NA PURCHASED
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C                   MOVEL     I#TREF        W#DLNO            6 0
     C     W#DLNO        CHAIN     MMDENBP0                           99        *
      *
      * If the deal is found
      * access other details
      * extract it
      * if not matured                                                                      BUG13562
      *
     C     *IN99         IFEQ      '0'
     C     HLDSTS        ANDNE     'M'                                                      BUG13562
     C     HLDDLT        ANDEQ     *BLANK                                                   AR582204
     C                   EXSR      ACS_OTHER_DTLS
     C     RECI          IFNE      'M'                                                      AR644662
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
     C                   CALLB     'GOXTNASP'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM      I#LOC         W#LOC             4
     C                   PARM      I#CCID        W#CCID           10 0

     C                   PARM      I#RDNB        W#RDNB            5 0
     C                   PARM      I#DNWD        W#DNWD            5 0
     C                   PARM      I#PCOD        W#PCOD            5 0
     C                   PARM      Trade_Value   W#TVDI            1
     C                   PARM                    MMDENB
     C                   PARM                    DEALDD

      * If data error encountered, log error

     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = 'NASP' + I#EXTT + I#TREF
     C                             + W#RTCD + W#ERMS + MMDENB
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
      * Get further deal details needed from DEALSDD
      *
     C                   CLEAR                   DEALDD
     C     HLDN38        CHAIN     DEALSDDF                           99        *

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
(c) Finastra International Limited 2003
