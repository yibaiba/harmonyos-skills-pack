# UI Design Kit（UI设计套件）（离线参考）

> 来源：华为 HarmonyOS 开发者文档

---

## UI Design Kit简介

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ui-design-introduction

UI Design Kit是华为提供的符合HarmonyOS Design System规范的UI界面开发套件集合。通过提供多样式的扩展组件、丰富的光影效果，支撑开发者高效构建高端精致的界面（参见HarmonyOS设计理念），确保应用在HarmonyOS全场景设备上达成一致的视觉体验与设计品质，遵循HarmonyOS设计规范。

扩展组件

	

光影效果

	

多设备适配




多样化的组件样式

	

丰富UI界面光影

	

全场景一致体验

功能全景
增强型UI组件

组件分类

	

组件描述




组件导航（HdsNavigation/HdsNavDestination）

	

提供HdsNavigation组件作为路由导航的根视图容器，HdsNavDestination作为子页面的根容器，实现灵活跳转操作；扩展标题栏交互，支持动态模糊与菜单气泡。




侧边栏（HdsSideBar）与侧边栏菜单（HdsSideMenu）

	

侧边栏：提供可显隐的侧边栏容器，支持自定义内容区。

侧边栏菜单：配套菜单组件支持一、二级菜单样式及新消息红点提醒。




底部页签（HdsTabs）

	

支持视图切换，提供分割线动态显隐、背景模糊、图标出血及半屏居中布局等增强样式。




即时操作（HdsSnackBar）与核心操作栏（HdsActionBar）

	

即时操作：提供非模态通知组件，支持图文展示与快速操作按钮，用于轻量化交互反馈。

核心操作栏：组合多个按钮，支持主按钮展开/收起的联动动效。




列表（HdsListItem）

	

封装高端卡片样式，内置横滑删除动效，适配多设备系统风格。




应用内多窗（MultiWindowEntryInAPP）

	

单应用多窗口入口，支持自定义图标、背板颜色与大小，实现多窗并行。

HDS沉浸视效

光效功能

	

功能描述




物理光感系统

	

提供点光源、边缘流光及背景流光。特有“自带背景双边流光”接口，完美适配胶囊组件与屏幕边缘发光场景。




按压交互阴影

	

提供按压阴影接口，自动计算组件在按压交互时的背景色变化效果，增强触控真实感。

资源与图标能力

能力分类

	

能力说明




应用图标处理

	

支持单层或分层图标的合成、剪切、缩放及描边，提供高效的批量处理能力。




自定义 Symbol

	

支持注册应用侧图标与动效资源，配合 ArkUI 组件展示，保持系统级视觉一致性。

与ArkUI基础能力的关系

UI Design Kit的导航、页签、列表、光效、应用交互等能力是基于ArkUI以下能力维度的扩展。

能力维度

	

ArkUI基础能力

	

UI Design Kit能力




组件导航

	

基础跳转

	

沉浸式体验：动态模糊标题栏、半模态样式、标题栏自定义区域、文字/图片双类型图标等




底部页签

	

基础切换

	

视觉增强：分割线动态显隐、页签栏模糊、图标出血设计、半屏居中对齐




列表交互

	

普通展示

	

高端动效：内置横滑删除、统一样式卡片、多设备适配




光影视觉

	

基础平面/材质

	

增强视效：提供点光源、流光、按压阴影等系统级沉浸渲染能力




应用交互

	

单窗口

	

多窗并行：提供应用内多窗组件，支持自定义背板、图标与文字样式




Symbol图标

	

依赖系统预置

	

解耦灵活：应用内注册自定义Symbol，不需提前预置系统

约束与限制
支持的国家和地区

UI Design Kit当前仅支持中国境内（香港特别行政区、澳门特别行政区、中国台湾除外）。

支持的设备

UI Design Kit提供的能力

	

支持的设备类型




图标处理

	

Phone、Tablet、PC/2in1、TV




组件导航

	

Phone、Tablet、PC/2in1、TV




侧边栏样式

	

Phone、Tablet、PC/2in1、TV




侧边栏菜单样式

	

Phone、Tablet、PC/2in1、TV




底部页签

	

Phone、Tablet、PC/2in1




即时操作

	

Phone、Tablet、PC/2in1、TV




核心操作栏

	

Phone、Tablet、PC/2in1、TV




列表

	

Phone、Tablet、PC/2in1、Wearable、TV




应用加载自定义Symbol

	

Phone、Tablet、PC/2in1、TV




HDS视效

	

Phone、Tablet、PC/2in1




应用内多窗

	

Phone、Tablet

能力限制
HdsNavigation/HdsNavDestination：横屏且导航栏为Stack模式时，不支持合并工具栏到菜单栏，标题栏默认采用层叠布局（位于内容区上层）。
图标批量处理接口：最大并发数为 10，单次最大处理量 500 个。
Symbol资源注册接口：仅支持注册 1 组图标资源与动效参数资源，最大支持 10 个自定义图标与动效参数资源注册。
模拟器支持情况

本Kit支持模拟器开发，但与真机存在部分能力差异，具体差异如下：

通用差异：请参见“模拟器与真机的差异”。
不支持HDS沉浸视效，包括点光源效果、按压阴影、双边边缘流光、背景流光和自带背景的双边流光。

---

## 图标处理

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ui-design-icon-process

（推荐）分层图标处理

单层图标处理


---

## 组件导航

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ui-design-navigation

设置动态模糊样式

设置信息提醒

设置自定义区域

标题栏动态显隐

半模态样式

图标类型设置

设置应用内多窗

开发实例


---

## 侧边栏样式

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ui-design-sidebar

设置overlay模式的侧边栏

设置embed模式的侧边栏


---

## 侧边栏菜单样式

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ui-design-side-menu

场景介绍

从6.0.0(20) Beta1版本开始，新增支持设置侧边栏菜单样式。

HdsSideMenu提供一种菜单栏样式组件。设置侧边栏对应的一级菜单和二级菜单，并显示其新消息数量。

开发步骤
导入相关模块。

import { HdsSideMenu, HdsSideMenuMainItem, HdsSideMenuSubItem, HdsSideMenuBadgeParam, HdsSideBar } from '@kit.UIDesignKit';
import { SymbolGlyphModifier } from '@kit.ArkUI';

设置对应的一级菜单和二级菜单，并显示其新消息数量。

@Entry
@ComponentV2
struct Index {
  @Local showControlButton: boolean = true;
  @Local sideBarMask: boolean = false;
  @Local autoHide: boolean = true;
  @Local barStateTypeText: string = "Select BarState";
  @Local widthIndex: number = 0;
  @Local badgeNumber: HdsSideMenuBadgeParam = { count: 50 };
  @Local useTheme: boolean = false;
  @Local selectedIndex: number = 2;
  @Local selectedTransparency: number = 0.6;
  @Local str: string = "短信";
  @Local isShowSidebar: boolean = true;
  listOptionsDefault?: HdsSideMenuMainItem[] = [
    new HdsSideMenuMainItem(
      {
        symbol: new SymbolGlyphModifier($r('sys.symbol.ohos_folder_badge_plus')).fontSize(14),
        label: $r('sys.string.TextView_engr_phone'),
      }),
    new HdsSideMenuMainItem({
      icon: $r('sys.symbol.person_wave_3'),
      label: 'Tuesday',
      hdsSideMenuSubItem: [
        new HdsSideMenuSubItem({ label: this.str, badge: this.badgeNumber })],
    }),
    new HdsSideMenuMainItem({
      symbol: new SymbolGlyphModifier($r('sys.symbol.person_crop_circle_fill_1')),
      label: 'Wednesday',
    }),
  ]
  @Builder
  SideBarPanelBuilder() {
    Column() {
      HdsSideMenu({
        items: this.listOptionsDefault,
        selectedIndex: this.selectedIndex,
        $selectedIndex: (selectedIndex: number) => {
          this.selectedIndex = selectedIndex;
        },
      })
    }
    .height('100%')
  }
  //右侧内容区
  @Builder
  ContentPanelBuilder() {
    Column() {
      Column() {
        Button() {
          SymbolGlyph(this.isShowSidebar ? $r('sys.symbol.open_sidebar') : $r('sys.symbol.close_sidebar'))
            .fontWeight(FontWeight.Normal)
            .fontSize($r('sys.float.ohos_id_text_size_headline7'))
            .fontColor([$r('sys.color.ohos_id_color_titlebar_icon')])
            .hitTestBehavior(HitTestMode.None)
        }
        .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
        .height(24)
        .width(24)
        .animation({ curve: Curve.Sharp, duration: 100 })
        .onClick(() => {
          this.isShowSidebar = !this.isShowSidebar;
        })
      }
    }
    .height('100%')
    .width('100%')
  }
  @BuilderParam sideBarBuilder: () => void = this.SideBarPanelBuilder
  @BuilderParam contentBuilder: () => void = this.ContentPanelBuilder
  @Builder
  build() {
    Column() {
      HdsSideBar({
        sideBarPanelBuilder: (): void => {
          this.sideBarBuilder()
        },
        contentPanelBuilder: (): void => {
          this.contentBuilder()
        },
        isShowSideBar: this.isShowSidebar,
        $isShowSideBar: (isShowSidebar: boolean) => {
          this.isShowSidebar = !isShowSidebar
        },
      })
    }
  }
}

---

## 底部页签

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ui-design-hds-tabs

设置页签栏的分割线

设置页签栏的模糊样式

设置页签的图标出血样式

设置侧边栏半屏居中对齐样式


---

## 即时操作

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ui-design-snackbar

设置常驻通知弹窗

设置定时通知弹窗


---

## 核心操作栏

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ui-design-actionbar

设置有主按钮的组件

设置无主按钮的组件


---

## 列表

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ui-design-list-item-card

设置附带横滑的列表样式

设置列表卡片样式


---

## 应用加载自定义Symbol

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ui-design-config-custom-symbol

资源注册


---

## 视效

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ui-design-visual-effect

点光源效果

按压阴影

双边边缘流光

背景流光

自带背景的双边流光


---

## 应用内多窗

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ui-design-multiwindowentryinapp

场景介绍

从6.0.0(20)Beta3版本开始，新增支持应用内多窗。

通过应用内多窗组件MultiWindowEntryInAPP提供的单应用多窗口接口，实现一个应用多个窗口并行运行的体验。并且可以设置图标大小颜色、背板大小颜色、文字大小颜色等。

如果开发者未集成HdsNavigation组件，可使用应用内多窗组件实现应用内多窗体验。

约束条件

依赖全景多窗特性，只有当前设备及屏幕状态支持全景多窗，才支持设置此功能。目前支持全景多窗的设备形态有：

双折叠：展开态。
三折叠：双屏态，三屏态的横屏态。
平板：横屏态。

对于不支持的设备形态，该组件不可交互，不响应点击事件。

开发步骤
导入模块。

// 从6.0.2(22)版本开始，无需手动导入MultiWindowEntryInAPPAttribute。具体请参考MultiWindowEntryInAPP的导入模块说明。
import { MultiWindowEntryInAPP, MultiWindowEntryInAPPAttribute } from '@kit.UIDesignKit';
import { Want } from '@kit.AbilityKit';
import { TextModifier }  from '@kit.ArkUI';

使用MultiWindowEntryInAPP组件，并且设置组件参数。

@Entry
@Component
struct MultiWindowEntryInAPPTest {
  @State textModifier: TextModifier = new TextModifier();
  private want: Want = {
    // 修改为当前应用的bundleName、moduleName、abilityName，启动应用内的UIAbility
    bundleName: "com.example.myapplication",
    moduleName: "entry",
    abilityName: "FuncAbility",
  };


  build() {
    Row() {
      MultiWindowEntryInAPP({
        want: this.want, isShowSubtitle: true, multiWindowEntryInAPPStyle: {
          iconOptions: {
            iconSize: 24,
            iconColor: $r('sys.color.font_primary'),
            iconWeight: FontWeight.Normal,
            backgroundColor: $r('sys.color.comp_background_tertiary')
          },
          subtitleOptions: {
            modifier: this.textModifier.fontColor(Color.Black)
          }
        }
      })
        .size({ width: 48, height: 48 })
        .position({ x: 400, y: 30 })
    }
  }
}

---

## UI Design Kit常见问题

**来源**: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ui-design-faq

怎么获取layeredDrawableDescriptor对象信息？


